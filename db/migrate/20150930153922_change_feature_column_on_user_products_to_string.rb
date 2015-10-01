class ChangeFeatureColumnOnUserProductsToString < ActiveRecord::Migration
  def change
  	change_table :user_products do |t|
	  t.remove :feature_id
	  t.string :feature
	end
  end
end
