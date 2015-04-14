class AddPolymorphicsColumnsForAdminLocationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :admin_location_type, :string
    add_column :users, :admin_location_id, :integer
  end
end
