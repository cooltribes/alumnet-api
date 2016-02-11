class Region < ActiveRecord::Base
  include RegionHelpers
  ### Relations
  has_many :countries, dependent: :nullify
  has_many :groups, through: :countries
  has_many :events, through: :countries
  has_many :profiles_residence, through: :countries
  has_many :users, through: :profiles_residence

  ### Validations
  validates_presence_of :name

  ### Instance Methods
  def admins
    User.where(admin_location_id: id, admin_location_type: "Region", role: "RegionalAdmin")
  end
end
