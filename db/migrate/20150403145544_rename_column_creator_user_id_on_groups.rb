class RenameColumnCreatorUserIdOnGroups < ActiveRecord::Migration
  def change
    rename_column :groups, :creator_user_id, :creator_id
  end
end
