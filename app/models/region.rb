class Region < ActiveRecord::Base
  include RegionHelpers
  ### Relations
  has_many :countries, dependent: :nullify
  has_many :users, through: :countries
  has_many :groups, through: :countries
  has_many :events, through: :countries

  ### Validations
  validates_presence_of :name

  ### Instance Methods
  def admins
    User.where(admin_location_id: id, admin_location_type: "Region", role: "RegionalAdmin")
  end
end
