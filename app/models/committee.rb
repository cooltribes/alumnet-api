class Committee < ActiveRecord::Base
  ###Relations
  belongs_to :country, foreign_key: "cc_fips"

  ## Types: "International", "National", "Local"
end
