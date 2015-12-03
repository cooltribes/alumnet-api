class CreateEmailPreferences < ActiveRecord::Migration
  def change
    create_table :email_preferences do |t|
      t.string :name
      t.integer :user_id
      t.integer :value

      t.timestamps null: false
    end
    add_index :email_preferences, :user_id
  end
end
