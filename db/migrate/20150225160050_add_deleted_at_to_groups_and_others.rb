class AddDeletedAtToGroupsAndOthers < ActiveRecord::Migration
  def change
    add_column :groups, :deleted_at, :datetime
    add_index :groups, :deleted_at
    add_column :memberships, :deleted_at, :datetime
    add_index :memberships, :deleted_at
    add_column :posts, :deleted_at, :datetime
    add_index :posts, :deleted_at
    add_column :comments, :deleted_at, :datetime
    add_index :comments, :deleted_at
    add_column :likes, :deleted_at, :datetime
    add_index :likes, :deleted_at
  end
end
