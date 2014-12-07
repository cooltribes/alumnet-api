class Profile < ActiveRecord::Base
  mount_uploader :avatar, AvatarUploader
  enum register_step: [:initial, :profile, :contact, :experience_a, :experience_b, :experience_c, :experience_d, :skills, :approval]

  ###Relations
  belongs_to :user
  has_many :contact_infos
  has_many :experiences
  has_many :language_levels
  has_many :languages, through: :language_levels
  has_and_belongs_to_many :skills

  ###Validations
  validates_presence_of :user_id, :first_name, :last_name, on: :update
  validates_inclusion_of :genre, in: ["M", "F"], on: :update

  ###Nested Atrributes
  accepts_nested_attributes_for :contact_infos, allow_destroy: true
  accepts_nested_attributes_for :experiences, allow_destroy: true
  accepts_nested_attributes_for :languages, allow_destroy: true
  accepts_nested_attributes_for :skills, allow_destroy: true



  ###Instance Methods
  def languages_attributes=(collection_attributes)
    collection_attributes.each do |attributes|
      language_levels.build(language_id: attributes["language_id"], level: attributes["level"])
    end
  end

  def skills_attributes=(skill_names)
    skill_names.each do |name|
      skill = Skill.find_or_create_by(name: name)
      skills << skill
    end
  end

  def update_step
    case register_step
      when "initial" then profile!
      when "profile" then contact!
      when "contact" then experience_a!
      when "experience_a" then experience_b!
      when "experience_b" then experience_c!
      when "experience_c" then experience_d!
      when "experience_d" then skills!
      when "skills" then approval!
    end
  end
end
