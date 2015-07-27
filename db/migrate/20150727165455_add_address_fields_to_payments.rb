class AddAddressFieldsToPayments < ActiveRecord::Migration
  def change
  	add_reference :payments, :country, index: true, foreign_key: true
    add_reference :payments, :city, index: true, foreign_key: true
    add_column :payments, :address, :string
  end
end
