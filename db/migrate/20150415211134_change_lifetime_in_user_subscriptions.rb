class ChangeLifetimeInUserSubscriptions < ActiveRecord::Migration
  def change
  	change_column :user_subscriptions, :lifetime, 'boolean USING CAST(lifetime AS boolean)', default: false
  end
end
