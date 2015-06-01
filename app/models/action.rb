class Action < ActiveRecord::Base
  # status
  # 0 -> Active
  # "1" -> All Members can invite, but the admins approved
  # "2" -> Only the admins can invite
  enum status: [:active, :inactive]

  # Relations
  has_many :user_actions, dependent: :destroy

  ### Validations
  validates_presence_of :name, :description, :value     
end