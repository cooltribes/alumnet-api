class LanguageLevel < ActiveRecord::Base
  ### Relations
  belongs_to :profile
  belongs_to :language

  ### Validations
  validates_inclusion_of :level, in: (1..5)
end
