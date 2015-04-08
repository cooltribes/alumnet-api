class AddDeletedAtToUsersAndOthers < ActiveRecord::Migration
  def change
    add_column :users, :deleted_at, :datetime
    add_index :users, :deleted_at
    add_column :friendships, :deleted_at, :datetime
    add_index :friendships, :deleted_at
    add_column :privacies, :deleted_at, :datetime
    add_index :privacies, :deleted_at
    add_column :profiles, :deleted_at, :datetime
    add_index :profiles, :deleted_at
    add_column :contact_infos, :deleted_at, :datetime
    add_index :contact_infos, :deleted_at
    add_column :experiences, :deleted_at, :datetime
    add_index :experiences, :deleted_at
    add_column :language_levels, :deleted_at, :datetime
    add_index :language_levels, :deleted_at
  end
end
