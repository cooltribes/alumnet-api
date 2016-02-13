class Country < ActiveRecord::Base

  ### Relations
  has_many :cities, foreign_key: "cc_iso", primary_key: "cc_iso"
  has_many :committees, foreign_key: "cc_fips", primary_key: "cc_fips"
  has_many :profiles_residence, class_name: "Profile", foreign_key: "residence_country_id"
  has_many :profiles_birth, class_name: "Profile", foreign_key: "birth_country_id"
  has_many :users, through: :profiles_residence
  has_many :groups
  has_many :events
  has_many :branches
  belongs_to :region

  ### Scopes
  default_scope { order('name') }
  scope :availables, -> { where(region_id: nil) }

  ### Instance Methods
  def admins
    User.where(admin_location_id: id, admin_location_type: "Country", role: "NacionalAdmin")
  end

end
