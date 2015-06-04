class CreateUserPrizes < ActiveRecord::Migration
  def change
    create_table :user_prizes do |t|
      t.integer :price
      t.integer :status
      t.references :user, index: true
      t.references :prize, index: true

      t.timestamps null: false
    end
  end
end
