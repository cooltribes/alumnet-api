class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.references :user, index: true
      t.references :paymentable, polymorphic: true
      t.decimal :subtotal
      t.decimal :iva
      t.decimal :total
      t.string :reference
      t.timestamps
    end
  end
end