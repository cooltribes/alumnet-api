class CreateFriendships < ActiveRecord::Migration
  def change
    create_table :friendships do |t|
      t.integer :friend_id
      t.references :user, index: true
      t.boolean :accepted, default: false

      t.timestamps
    end
    add_index :friendships, :friend_id
  end
end
