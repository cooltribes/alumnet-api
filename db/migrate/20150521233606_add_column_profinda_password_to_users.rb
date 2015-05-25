class AddColumnProfindaPasswordToUsers < ActiveRecord::Migration
  def change
    add_column :users, :profinda_password, :string
  end
end
