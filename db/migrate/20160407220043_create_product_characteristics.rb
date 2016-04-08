class CreateProductCharacteristics < ActiveRecord::Migration
  def change
    create_table :product_characteristics do |t|
    	t.references :characteristic, index: true, foreign_key: true
		t.references :product, index: true, foreign_key: true

		t.timestamps null: false
    end
  end
end
