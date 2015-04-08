class AddColumnProfileUIdToContacInfos < ActiveRecord::Migration
  def change
    add_column :contact_infos, :profile_id, :integer
    add_index :contact_infos, :profile_id
  end
end
