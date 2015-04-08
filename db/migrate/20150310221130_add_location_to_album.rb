class AddLocationToAlbum < ActiveRecord::Migration
  def change
    add_column :albums, :city_id, :integer
    add_index :albums, :city_id    
    add_column :albums, :country_id, :integer
    add_index :albums, :country_id    
  end
end
