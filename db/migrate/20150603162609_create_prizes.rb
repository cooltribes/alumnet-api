class CreatePrizes < ActiveRecord::Migration
  def change
    create_table :prizes do |t|
      t.string :name
      t.string :description
      t.integer :price
      t.integer :status, default: 1
      t.integer :type

      t.timestamps null: false
    end
  end
end
