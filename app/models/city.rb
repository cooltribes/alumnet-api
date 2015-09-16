class City < ActiveRecord::Base
  belongs_to :country, foreign_key: "cc_iso", primary_key: "cc_iso"
  has_many :groups
end
