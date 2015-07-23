class Seniority < ActiveRecord::Base
  ## Relations
  has_many :experiences
  has_many :tasks

  ## Validations
  validates_presence_of :name, :seniority_type
end
