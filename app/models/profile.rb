class Profile < ActiveRecord::Base
  mount_uploader :avatar, AvatarUploader

  ###Relations
  belongs_to :user

  ###Validations
  validates_presence_of :first_name, :last_name, on: :update
end
