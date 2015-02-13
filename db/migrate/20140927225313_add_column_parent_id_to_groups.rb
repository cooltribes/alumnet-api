class AddColumnParentIdToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :parent_id, :integer
    add_index :groups, :parent_id
  end
end
