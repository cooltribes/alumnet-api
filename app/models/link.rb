class Link < ActiveRecord::Base
  ### Relations
  belongs_to :company_relation

  ### Validations
  validates_presence_of :title, :description, :url
end
