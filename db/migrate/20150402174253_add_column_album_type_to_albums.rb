class AddColumnAlbumTypeToAlbums < ActiveRecord::Migration
  def change
    add_column :albums, :album_type, :integer, default: 0
  end
end
