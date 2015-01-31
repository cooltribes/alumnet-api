class Country < ActiveRecord::Base
  has_and_belongs_to_many :regions
  has_many :cities, foreign_key: "cc_fips", primary_key: "cc_fips"
  has_many :committees, foreign_key: "cc_fips", primary_key: "cc_fips"
  has_many :groups
end
