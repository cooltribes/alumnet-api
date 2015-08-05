class CreateCompaniesProductsServices < ActiveRecord::Migration
  def change
    create_table :companies_products_services, id: false do |t|
      t.belongs_to :company, index: true
      t.belongs_to :product_service, index: true
    end
  end
end
