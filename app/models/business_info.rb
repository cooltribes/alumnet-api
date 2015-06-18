class BusinessInfo < ActiveRecord::Base
    
  ###Constants
  INFO_TYPE = { 0 => 'Offer', 1 => 'Search', 2 => 'Free' }

  ###Relations
  belongs_to :company_relation
  has_and_belongs_to_many :keywords


  ###Validations
  validates_presence_of :title
end
