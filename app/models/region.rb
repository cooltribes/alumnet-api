class Region < ActiveRecord::Base
  ### Relations
  has_many :countries
end
