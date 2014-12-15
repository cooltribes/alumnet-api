class RenameColumnsResetPasswordOnUsers < ActiveRecord::Migration
  def change
    rename_column :users, :reset_passoword_token, :password_reset_token
    rename_column :users, :reset_password_created_at, :password_reset_send_at
  end
end
