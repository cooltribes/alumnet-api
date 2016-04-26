class AddPricesToProducts < ActiveRecord::Migration
  def change
    add_column :products, :sale_price, :decimal
    add_column :products, :tax_rule, :integer, default: 0
    add_column :products, :tax_value, :decimal
    add_column :products, :discount_type, :integer, default: 0
    add_column :products, :discount_value, :decimal
    add_column :products, :total_price, :decimal
    remove_column :products, :price, :decimal
  end
end
