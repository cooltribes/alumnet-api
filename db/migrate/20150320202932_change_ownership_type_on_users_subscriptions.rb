class ChangeOwnershipTypeOnUsersSubscriptions < ActiveRecord::Migration
  def change
  	change_table :user_subscriptions do |t|
	  t.rename :ownership_type_integer, :ownership_type
	end
  end
end
