class Task < ActiveRecord::Base
  acts_as_paranoid
  include Alumnet::Localizable
  include Alumnet::Searchable

  ## Relations
  has_many :matches, dependent: :destroy
  has_many :task_invitations, dependent: :destroy
  has_many :task_attributes, dependent: :destroy
  belongs_to :user
  belongs_to :seniority
  belongs_to :company


  EMPLOYMENT_TYPES = { 0 => "Full-time", 1 => "Part-time", 2 => "Internship", 3 => "Temporary", 4 => "Special Assignment", 5 => "Specialized Group"}
  POSITION_TYPES = { 0 => "Top Management/Director", 1 => "Middle management", 2 => "Senior Specialist",
    3 => "Junior Specialist", 4 => "Entry job" }

  HELP_TYPES = {"task_business_exchange" => "Business Opportunity", "task_home_exchange" => "Home Exchange",
    "task_job_exchange" => "Job Post", "task_meetup_exchange" => "Meet-up"}


  enum application_type: [ :alumnet, :external ]

  ## Validations
  validates_presence_of :name, :description, :nice_have_list, :help_type, :post_until, :user_id
  validates_presence_of :arrival_date,  if: Proc.new { |t| t.task_meetup_exchange? }
  validates_presence_of :company_id,  if: Proc.new { |t| t.task_job_exchange? }

  ## Scopes
  scope :business_exchanges, -> { where(help_type: "task_business_exchange") }
  scope :home_exchanges, -> { where(help_type: "task_home_exchange") }
  scope :job_exchanges, -> { where(help_type: "task_job_exchange") }
  scope :meetup_exchanges, -> { where(help_type: "task_meetup_exchange") }

  scope :current_meetups, -> { where("arrival_date >= ?", Date.today) }
  scope :current_tasks, -> { where("post_until >= ?", Date.today) }

  ## Callbacks
  before_validation :check_help_type_and_set_values
  after_save :set_task_attributes

  ## Dinamics methods

  HELP_TYPES.keys.each do |type|
    define_method("#{type}?") do
      help_type == type
    end
  end

  ## Instance methods
  def as_indexed_json(options = {})
    as_json(methods: [:city_info, :country_info],
      include: { task_attributes: { only: [:value, :attribute_type] } })
  end

  def apply(user)
    match = matches.find_or_initialize_by(user: user)
    match.applied = true
    if match.save
      UserMailer.meetup_apply(user, self).deliver_later if task_meetup_exchange?
    end
  end

  def can_apply(user)
    return false if self.user == user
    !user_applied?(user) && !user.is_external?
  end

  def user_applied?(user)
    match = matches.find_by(user_id: user.id)
    match ? match.applied? : false
  end

  def delete_all_tasks_attributes(attribute_type = "nice_have")
    attribute_type == "nice_have" ? task_attributes.nice_have.delete_all : task_attributes.must_have.delete_all
  end

  def nice_have_array
    nice_have_list.split(",")
  end

  def must_have_array
    must_have_list.split(",")
  end

  def employment_type_text
    EMPLOYMENT_TYPES[employment_type]
  end

  def position_type_text
    seniority.try(:name)
  end

  def company_info
    { text: company.try(:name) || "", id: company_id || "" }
  end

  def position_info
    { text: position_type_text, id: seniority_id }
  end

  def employment_info
    { text: employment_type_text, id: employment_type }
  end

  def type_text
    HELP_TYPES[help_type]
  end

  #HINT: THIS IS HORRIBLE FOR THE API
  def ui_url
    help_type.gsub("_", "-").gsub("task-", "#")
  end

  # PROFINDA INTEGRATION

  def create_profinda_task
    CreateProfindaTaskJob.perform_later(id)
  end

  def update_profinda_task
    UpdateProfindaTaskJob.perform_later(id)
  end

  def delete_profinda_task
    if user && profinda_id
      DeleteProfindaTaskJob.perform_later(user.id, profinda_id)
    end
  end

  def create_in_profinda
    if user && profinda_api.valid?
      profinda_task = profinda_api.create_task(profinda_attributes, help_type)
      if profinda_task
        update_column(:profinda_id, profinda_task["id"])
        matches = profinda_api.matches(profinda_task["id"])
        save_matches(matches)
      end
    end
  end

  def update_in_profinda
    if profinda_id && profinda_api.valid?
      profinda_api.update_task(profinda_id, profinda_attributes)
      matches = profinda_api.matches(profinda_id)
      save_matches(matches)
    end
  end

  def delete_from_profinda
    if user && profinda_id
      Task.delete_from_profinda(user, profinda_id)
    end
  end

  def profinda_matches
    if profinda_id && profinda_api.valid?
      matches = profinda_api.matches(profinda_id)
      save_matches(matches)
    end
  end

  def save_matches(p_matches)
    matches.delete_with_profinda_uid(p_matches)
    User.where(profinda_uid: p_matches).each do |user|
      matches.find_or_create_by(user: user)
      send_match_notification
    end
  end

  def profinda_attributes
    p_attributtes = attributes.slice("name", "description", "post_until", "duration",
      "must_have_list", "nice_have_list")
    p_attributtes.merge({"post_until" => post_until.strftime("%d/%m/%Y")})
  end

  def set_task_attributes_from_profinda(attribute_type = "nice_have")
    delete_all_tasks_attributes(attribute_type)
    dictionary_objects = get_dictionary_object_from_profinda(attribute_type)
    dictionary_objects.each do |dictionary_object|
      TaskAttribute.create_from_dictionary_object(self, dictionary_object, attribute_type)
    end
  end

  def get_dictionary_object_from_profinda(attribute_type = "nice_have")
    @profinda_admin_api ||= ProfindaAdminApiClient.new
    collection_ids = attribute_type == "nice_have" ? nice_have_array : must_have_array
    @profinda_admin_api.dictionary_objects_by_id(collection_ids)
  end

  def profinda_api
    @profinda_api ||= ProfindaApiClient.new(user.email, user.profinda_password)
  end

  def send_match_notification
    AdminMailer.send("match_#{help_type}", user, self).deliver_later
  end


  ## class methods

  def self.applied_by(user)
    joins(:matches).where(matches: { user_id: user.id }).where(matches: { applied: true })
  end

  def self.delete_from_profinda(user, profinda_id)
    if profinda_id
      profinda_api = ProfindaApiClient.new(user.email, user.profinda_password)
      profinda_api.delete_task(profinda_id) if profinda_api
    end
  end

  def self.profinda_automatches(user, help_type)
    profinda_api = ProfindaApiClient.new(user.email, user.profinda_password)
    if profinda_api
      profinda_tasks = profinda_api.automatches
      tasks = Task.current_tasks.where(profinda_id: profinda_tasks, help_type: help_type)
      tasks.each do |task|
        task.matches.find_or_create_by(user: user)
      end
      tasks
    end
  end

  private

    def set_task_attributes
      set_task_attributes_from_profinda
      set_task_attributes_from_profinda("must_have")
    end

    def check_help_type_and_set_values
      if new_record?
        case help_type
          when "task_job_exchange"
            self[:post_until] = Date.today + 60
        end
        self[:duration] = "hours"
      end
    end

end
