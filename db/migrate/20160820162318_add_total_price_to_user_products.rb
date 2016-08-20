class AddTotalPriceToUserProducts < ActiveRecord::Migration
  def change
    add_column :user_products, :total_price, :decimal
  end
end
