class Region < ActiveRecord::Base
  include RegionHelpers
  ### Relations
  has_many :countries, dependent: :nullify
  has_many :users, through: :countries
  has_many :groups, through: :countries
  has_many :events, through: :countries

  ### Validations
  validates_presence_of :name
end
