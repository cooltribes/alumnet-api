class AddColumnUploadFilesToGroupsAndEvents < ActiveRecord::Migration
  def change
    add_column :groups, :upload_files, :integer, default: 0
    add_column :events, :upload_files, :integer, default: 0
  end
end
