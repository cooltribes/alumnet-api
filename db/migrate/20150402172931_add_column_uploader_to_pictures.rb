class AddColumnUploaderToPictures < ActiveRecord::Migration
  def change
    add_column :pictures, :uploader_id, :integer
  end
end
