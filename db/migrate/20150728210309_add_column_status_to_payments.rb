class AddColumnStatusToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :status, :integer, default: 1
  end
end
