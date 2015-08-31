class CreateUserProducts < ActiveRecord::Migration
  def change
    create_table :user_products do |t|
      t.integer :status, default: 1
      t.datetime :start_date
      t.datetime :end_date
      t.integer :quantity
      t.integer :transaction_type
      t.references :user, index: true
      t.references :product, index: true

      t.timestamps null: false
    end
  end
end
