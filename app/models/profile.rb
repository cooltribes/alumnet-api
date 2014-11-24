class Profile < ActiveRecord::Base
  mount_uploader :avatar, AvatarUploader
  enum register_step: [:initial, :profile, :contact, :experience_a, :experience_b, :experience_c, :experience_d, :skills, :approval]

  ###Relations
  belongs_to :user
  has_many :contact_infos
  has_many :experiences

  ###Validations
  validates_presence_of :user_id
  validates_presence_of :first_name, on: :update

  ###Nested Atrributes
  accepts_nested_attributes_for :contact_infos, allow_destroy: true
  accepts_nested_attributes_for :experiences, allow_destroy: true

  ###Instance Methods

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
