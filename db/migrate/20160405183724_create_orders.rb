class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.references :user, index: true, foreign_key: true
      t.integer :status, default: 1
      t.decimal :subtotal
      t.decimal :tax
      t.decimal :discount
      t.decimal :total

      t.timestamps null: false
    end
  end
end
