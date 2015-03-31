class Profile < ActiveRecord::Base
  acts_as_paranoid
  mount_uploader :avatar, AvatarUploader
  enum register_step: [:initial, :profile, :contact, :experience_a, :experience_b, :experience_c, :experience_d, :skills, :approval]
  include ProfileHelpers

  ##Crop avatar
  attr_accessor :imgW, :imgH, :imgX1, :imgY1, :cropW, :cropH

  ###Relations
  belongs_to :birth_city, class_name: 'City'
  belongs_to :residence_city, class_name: 'City'
  belongs_to :birth_country, class_name: 'Country'
  belongs_to :residence_country, class_name: 'Country'
  belongs_to :user
  has_many :contact_infos, dependent: :destroy
  has_many :experiences, dependent: :destroy
  has_many :language_levels, dependent: :destroy
  has_many :languages, through: :language_levels
  has_and_belongs_to_many :skills

  ###Validations
  validates_presence_of :user_id, :first_name, :last_name, on: :update
  validates_inclusion_of :gender, in: ["M", "F"], on: :update
  validate :born_date

  ###Nested Atrributes
  accepts_nested_attributes_for :contact_infos, allow_destroy: true
  accepts_nested_attributes_for :experiences, allow_destroy: true
  accepts_nested_attributes_for :languages, allow_destroy: true
  accepts_nested_attributes_for :skills, allow_destroy: true

  ###Instance Methods

  def crop_avatar
    avatar.recreate_versions! if imgX1.present?
  end

  def hidden_last_name
    if last_name
      "#{last_name.first}."
    else
      nil
    end
  end

  def local_committee
    if first_aiesec_experience
      first_aiesec_experience.committee if first_aiesec_experience.committee.present?
    end
  end

  def first_aiesec_experience
    experiences.where(exp_type: 0).first
  end

  def last_experience
    experiences.where.not(exp_type: 2).last
  end

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

  private
    def born_date
      if born.present? && ((Date.current - born).to_i / 365 ) < 20
        errors.add(:born, 'you must have more than 20 years')
      end
    end
end
