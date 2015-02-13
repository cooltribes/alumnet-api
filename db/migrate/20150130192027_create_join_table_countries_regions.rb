class CreateJoinTableCountriesRegions < ActiveRecord::Migration
  def change
    create_join_table :countries, :regions do |t|
      t.index [:country_id, :region_id]
      t.index [:region_id, :country_id]
    end
  end
end
