class UserAction < ActiveRecord::Base

  ###Relations
  belongs_to :user
  belongs_to :action

  ### Validations
  validates_presence_of :action_id, :user_id, :value

  attr_accessor :invited_user

end