class Language < ActiveRecord::Base
  ### Relations
  has_many :language_levels
  has_many :profiles, through: :language_levels

end
