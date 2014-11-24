class Country < ActiveRecord::Base
  has_many :cities, foreign_key: "cc_fips", primary_key: "cc_fips"
  has_many :committees, foreign_key: "cc_fips", primary_key: "cc_fips"
end
