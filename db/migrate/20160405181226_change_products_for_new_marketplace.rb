class ChangeProductsForNewMarketplace < ActiveRecord::Migration
  def change
  	change_table :products do |t|
	  t.remove :product_type, :quantity, :feature
	  t.integer :highlight
	  t.references :category, index: true, foreign_key: true
	end
  end
end
