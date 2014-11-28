class FixesOnUserColumns < ActiveRecord::Migration
  def change
    rename_column :users, :api_token, :auth_token
    add_column :users, :reset_passoword_token, :string
    add_column :users, :remember_token, :string
    add_column :users, :auth_token_created_at, :datetime
    add_column :users, :reset_password_created_at, :datetime
    add_column :users, :last_access_at, :datetime
  end
end
