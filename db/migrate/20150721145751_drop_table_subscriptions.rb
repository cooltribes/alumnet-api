class DropTableSubscriptions < ActiveRecord::Migration
  def change
  	drop_table :subscriptions
  end
end
