class User < ActiveRecord::Base
  has_secure_password

  ### Validations
  validates_presence_of :password, :on => :create
end
