class CreateUsersActions < ActiveRecord::Migration
  def change
    create_table :users_actions do |t|
      t.integer :value
      t.integer :generator_id
      t.string :generator_type
      t.references :user, index: true
      t.references :action, index: true
      t.timestamps
    end
  end
end