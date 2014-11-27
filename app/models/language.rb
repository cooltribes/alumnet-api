class Language < ActiveRecord::Base
  ### Relations
  has_and_belongs_to_many :profiles

end
