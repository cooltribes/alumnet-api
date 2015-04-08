class ChangeTypeOnSubscriptions < ActiveRecord::Migration
  def change
  	change_table :subscriptions do |t|
	  t.rename :type, :subscription_type
	end
  end
end
