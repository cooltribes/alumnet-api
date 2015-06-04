class CompanyRelation < ActiveRecord::Base

  ### Relations
  belongs_to :profile
  belongs_to :company
  # has_many :business_infos, dependent: :destroy
  has_many :company_relation_keywords
  has_many :keywords, through: :company_relation_keywords


  ### Validations
  validates_presence_of :offer, :search
  
end
