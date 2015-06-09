class Company < ActiveRecord::Base

  ### Relations
  belongs_to :profile  
  has_many :company_relations, dependent: :destroy  


  ### Validations
  validates_presence_of :name
  
end
