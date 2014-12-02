class AddColumnOfLocationToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :country_id, :integer, index: true
    add_column :groups, :city_id, :integer, index: true
    add_index :groups, :country_id
    add_index :groups, :city_id
  end
end
