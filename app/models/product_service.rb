class ProductService < ActiveRecord::Base
  self.table_name = "products_services"
  ### Relations
  has_and_belongs_to_many :companies, dependent: :destroy

  ###Validations
  validates_presence_of :name
  validates_uniqueness_of :name, case_sensitive: false

end
