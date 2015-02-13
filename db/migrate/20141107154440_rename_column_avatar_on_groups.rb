class RenameColumnAvatarOnGroups < ActiveRecord::Migration
  def change
    rename_column :groups, :avatar, :cover
  end
end
