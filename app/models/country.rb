class Country < ActiveRecord::Base

  ### Relations
  has_many :cities, foreign_key: "cc_fips", primary_key: "cc_fips"
  has_many :committees, foreign_key: "cc_fips", primary_key: "cc_fips"
  has_many :profiles, class_name: "Profile", foreign_key: "residence_country_id"
  has_many :users, through: :profiles
  has_many :groups
  has_many :events
  belongs_to :region

  ### Scopes
  default_scope { order('name') }
  scope :availables, -> { where(region_id: nil) }

end
