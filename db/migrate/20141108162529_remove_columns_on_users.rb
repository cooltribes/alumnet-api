class RemoveColumnsOnUsers < ActiveRecord::Migration
  def change
    remove_column :users, :name
    remove_column :users, :avatar
  end
end
