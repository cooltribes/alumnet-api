class Profile < ActiveRecord::Base
  mount_uploader :avatar, AvatarUploader
  enum register_step: [:initial, :profile, :contact, :experience, :skills, :approval]

  ###Relations
  belongs_to :user

  ###Validations
  validates_presence_of :user_id
  validates_presence_of :first_name, :last_name, on: :update

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
