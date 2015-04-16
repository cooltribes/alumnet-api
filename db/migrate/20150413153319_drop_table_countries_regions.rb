class DropTableCountriesRegions < ActiveRecord::Migration
  def change
    drop_table :countries_regions
  end
end
