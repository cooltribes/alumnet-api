class AdminNote < ActiveRecord::Base
  acts_as_paranoid

  ### Relations
  belongs_to :user

  ### Validations
  validates_presence_of :user_id
end
