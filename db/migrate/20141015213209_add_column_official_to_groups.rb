class AddColumnOfficialToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :official, :boolean
  end
end
