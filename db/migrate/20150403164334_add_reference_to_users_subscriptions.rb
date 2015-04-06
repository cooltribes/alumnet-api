class AddReferenceToUsersSubscriptions < ActiveRecord::Migration
  def change
    add_column :user_subscriptions, :reference, :integer
  end
end
