class AddColumnProfindaUidToUsers < ActiveRecord::Migration
  def change
    add_column :users, :profinda_uid, :integer
  end
end
