class AddLifetimeToUsersSubscriptions < ActiveRecord::Migration
  def change
    add_column :user_subscriptions, :lifetime, :integer
  end
end
