class Region < ActiveRecord::Base
  include RegionHelpers
  ### Relations
  has_many :countries, dependent: :nullify
end
