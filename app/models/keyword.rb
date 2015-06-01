class Keyword < ActiveRecord::Base
  ### Relations
  has_and_belongs_to_many :business_infos
end
