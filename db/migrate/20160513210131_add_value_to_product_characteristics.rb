class AddValueToProductCharacteristics < ActiveRecord::Migration
  def change
    add_column :product_characteristics, :value, :string
  end
end
