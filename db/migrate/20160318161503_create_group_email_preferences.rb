class CreateGroupEmailPreferences < ActiveRecord::Migration
  def change
    create_table :group_email_preferences do |t|
      t.integer :group_id
      t.integer :user_id
      t.integer :value

      t.timestamps null: false
    end
    add_index :group_email_preferences, :group_id
    add_index :group_email_preferences, :user_id
  end
end