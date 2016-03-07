class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.decimal :subtotal
      t.decimal :tax
      t.decimal :discount
      t.decimal :total
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
