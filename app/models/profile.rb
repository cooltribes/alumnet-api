class Profile < ActiveRecord::Base
  mount_uploader :avatar, AvatarUploader
  enum register_step: [:initial, :profile, :contact, :experience, :skills, :approval]

  ###Relations
  belongs_to :user
  has_many :contact_infos

  ###Validations
  validates_presence_of :user_id
  validates_presence_of :first_name, on: :update

  ###Nested Atrributes
  accepts_nested_attributes_for :contact_infos, allow_destroy: true

  ###Instance Methods

  def update_step
    case register_step
      when "initial" then profile!
      when "profile" then contact!
      when "contact" then experience!
      when "experience" then skills!
      when "skills" then approval!
    end
  end
end
