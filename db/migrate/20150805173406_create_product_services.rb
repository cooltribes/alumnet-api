class CreateProductServices < ActiveRecord::Migration
  def change
    create_table :products_services do |t|
      t.string :name
      t.integer :service_type, default: 1

      t.timestamps null: false
    end
  end
end
