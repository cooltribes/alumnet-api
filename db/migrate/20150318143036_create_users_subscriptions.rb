class CreateUsersSubscriptions < ActiveRecord::Migration
  def change
    create_table :user_subscriptions do |t|
      t.datetime :start_date
      t.datetime :end_date
      t.integer :status, default: 1
      t.string :ownership_type_integer
      t.references :user, index: true
      t.references :subscription, index: true
      t.references :creator, index: true
    end
  end
end
