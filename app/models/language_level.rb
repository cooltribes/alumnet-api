class LanguageLevel < ActiveRecord::Base
  acts_as_paranoid

  ### Relations
  belongs_to :profile
  belongs_to :language

  ### Validations
  validates_inclusion_of :level, in: (1..5)
end
