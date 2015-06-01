class Keyword < ActiveRecord::Base
  ### Relations
  has_and_belongs_to_many :business_infos
  has_many :company_relations, through: :company_relation_keywords
  
end
