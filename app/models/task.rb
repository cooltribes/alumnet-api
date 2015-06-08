class Task < ActiveRecord::Base
  acts_as_paranoid

  ## Relations
  has_many :matches, dependent: :destroy
  belongs_to :user
  belongs_to :city
  belongs_to :country

  # HELP TYPES
  # "task_business_exchange"
  # "task_home_exchange"
  # "task_job_exchange"
  # "task_meetup_exchange"

  ## Validations
  validates_presence_of :name, :description, :nice_have_list, :must_have_list,
    :help_type, :post_until

  ## Scopes
  scope :business_exchanges, -> { where(help_type: "task_business_exchange") }
  scope :home_exchanges, -> { where(help_type: "task_home_exchange") }
  scope :job_exchanges, -> { where(help_type: "task_job_exchange") }
  scope :meetup_exchanges, -> { where(help_type: "task_meetup_exchange") }

  ## Callbacks
  before_validation :check_help_type_and_set_values

  ## Instance methods

  def create_profinda_task
    CreateProfindaTaskJob.perform_later(id) unless Rails.env.test?
  end

  def update_profinda_task
    UpdateProfindaTaskJob.perform_later(id) unless Rails.env.test?
  end

  def delete_profinda_task
    if user && profinda_id
      DeleteProfindaTaskJob.perform_later(user.id, profinda_id) unless Rails.env.test?
    end
  end

  def create_in_profinda
    if user
      profinda_api = ProfindaApi.new(user.email, user.profinda_password)
      profinda_task = profinda_api.create_task(profinda_attributes, help_type)
      update_column(:profinda_id, profinda_task["id"])
      matches = profinda_api.matches(profinda_task["id"])
      save_matches(matches)
    end
  end

  def update_in_profinda
    if profinda_id
      profinda_api = ProfindaApi.new(user.email, user.profinda_password)
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
    if profinda_id
      profinda_api = ProfindaApi.new(user.email, user.profinda_password)
      matches = profinda_api.matches(profinda_id)
      save_matches(matches)
    end
  end

  def save_matches(p_matches)
    User.where(profinda_uid: p_matches).each do |user|
      matches.find_or_create_by(user: user)
    end
  end

  def profinda_attributes
    p_attributtes = attributes.slice("name", "description", "post_until", "duration",
      "must_have_list", "nice_have_list")
    p_attributtes.merge({"post_until" => post_until.strftime("%d/%m/%Y")})
  end

  def country_info
    country ? { text: country.name, value: country_id } : { text: "", value: ""}
  end

  def city_info
    city ? { text: city.name, value: city_id } : { text: "", value: ""}
  end

  def company_info
    company ? { text: company.name, value: company_id } : { text: "", value: ""}
  end
  def company;nil;end


  ## class methods

  def self.delete_from_profinda(user, profinda_id)
    if profinda_id
      profinda_api = ProfindaApi.new(user.email, user.profinda_password)
      profinda_api.delete_task(profinda_id)
    end
  end

  private

    def check_help_type_and_set_values
      if new_record?
        days = case help_type
          when "task_job_exchange" then 60
          else 0
        end
        self[:post_until] = Date.today + days
        self[:duration] = "hours"
      end
    end

end
