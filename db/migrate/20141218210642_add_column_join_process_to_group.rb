class AddColumnJoinProcessToGroup < ActiveRecord::Migration
  def change
    add_column :groups, :join_process, :integer
  end
end
