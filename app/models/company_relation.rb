class CompanyRelation < ActiveRecord::Base

  ### Relations
  belongs_to :profile
  belongs_to :company
  has_many :business_infos, dependent: :destroy


  ### Validations
  
end
