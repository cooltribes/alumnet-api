class Country < ActiveRecord::Base

  ### Relations
  has_many :cities, foreign_key: "cc_fips", primary_key: "cc_fips"
  has_many :committees, foreign_key: "cc_fips", primary_key: "cc_fips"
  has_many :groups
  belongs_to :region
end
