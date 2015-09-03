class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :sku
      t.string :name
      t.text :description
      t.integer :status, default: 1
      t.decimal :price
      t.integer :product_type
      t.integer :quantity
      t.string :feature

      t.timestamps null: false
    end
  end
end
