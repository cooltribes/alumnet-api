class CreateProductAttributes < ActiveRecord::Migration
  def change
    create_table :product_attributes do |t|
      t.references :attribute, index: true, foreign_key: true
      t.references :product, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
