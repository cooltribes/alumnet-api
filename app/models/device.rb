class Device < ActiveRecord::Base

  ### Relations
  belongs_to :user

  ### Validations
  validates_presence_of :token, :platform
end
