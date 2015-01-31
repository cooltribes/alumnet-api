class Experience < ActiveRecord::Base
  ### Relations
  belongs_to :region
  belongs_to :city
  belongs_to :country
  belongs_to :profile
  belongs_to :committee
end
