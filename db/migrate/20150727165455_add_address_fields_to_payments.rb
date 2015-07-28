class AddAddressFieldsToPayments < ActiveRecord::Migration
  def change
  	add_column :payments, :country_id, :integer
    add_column :payments, :city_id, :integer
    add_column :payments, :address, :string
  end
end
