class Committee < ActiveRecord::Base
  belongs_to :country, foreign_key: "cc_fips"
end
