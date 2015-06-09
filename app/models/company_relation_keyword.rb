class CompanyRelationKeyword < ActiveRecord::Base

  ### Relations
  belongs_to :company_relation
  belongs_to :keyword

  ### Validations
  validates_inclusion_of :keyword_type, in: (0..1)

end
