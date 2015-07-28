class ReCreateTableSubscriptions < ActiveRecord::Migration
  def change
  	create_table :subscriptions do |t|
	  	t.datetime :start_date
	    t.datetime :end_date
	    t.integer :status, default: 1
	    t.integer :ownership_type
	    t.boolean :lifetime, default: false
	    t.references :user, index: true
	    t.references :creator, index: true
	    t.timestamps
	end
  end
end
