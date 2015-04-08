class City < ActiveRecord::Base
  belongs_to :country, foreign_key: "cc_fips"
  has_many :groups
end
