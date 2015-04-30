class AddPaymentColumnsToEvents < ActiveRecord::Migration
  def change
    add_column :events, :admission_type, :integer, default: 0
    add_column :events, :regular_price, :decimal
    add_column :events, :premium_price, :decimal
  end
end
