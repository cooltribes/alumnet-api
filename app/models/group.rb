class Group < ActiveRecord::Base
  ### Validations
  validates_presence_of :name, :description, :avatar, :group_type
end
