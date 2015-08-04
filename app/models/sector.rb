class Sector < ActiveRecord::Base
  ### Relations
  has_many :companies
end
