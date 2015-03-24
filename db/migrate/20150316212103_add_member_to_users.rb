class AddMemberToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :member, :integer, default: 0
  end
end
