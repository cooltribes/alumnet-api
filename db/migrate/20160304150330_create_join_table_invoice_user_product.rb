class CreateJoinTableInvoiceUserProduct < ActiveRecord::Migration
  def change
    create_join_table :invoices, :user_products do |t|
      t.index [:invoice_id, :user_product_id]
      t.index [:user_product_id, :invoice_id]

      t.timestamps null: false
    end
  end
end
