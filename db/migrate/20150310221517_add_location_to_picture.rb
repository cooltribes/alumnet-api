class AddLocationToPicture < ActiveRecord::Migration
  def change
    add_column :pictures, :city_id, :integer
    add_index :pictures, :city_id    
    add_column :pictures, :country_id, :integer
    add_index :pictures, :country_id
  end
end
