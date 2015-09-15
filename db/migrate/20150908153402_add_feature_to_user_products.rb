class AddFeatureToUserProducts < ActiveRecord::Migration
  def change
    add_column :user_products, :feature_id, :integer
    add_index :user_products, :feature_id
  end
end
