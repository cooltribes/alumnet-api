class AddColumnCreatedByAdminToUsers < ActiveRecord::Migration
  def change
    add_column :users, :created_by_admin, :boolean, default: false
  end
end
