class AddColumnCreatorUserIdToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :creator_user_id, :integer
  end
end
