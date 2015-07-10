class Feature < ActiveRecord::Base
  # status
  # 0 -> Inctive
  # 1 -> Active
  enum status: [:inactive, :active]

  ### Validations
  validates_presence_of :name, :description, :key_name     
end