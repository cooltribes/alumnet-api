class Experience < ActiveRecord::Base
  ### Relations
  belongs_to :city
  belongs_to :country
  belongs_to :profile
end
