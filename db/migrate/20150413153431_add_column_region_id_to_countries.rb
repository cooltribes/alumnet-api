class AddColumnRegionIdToCountries < ActiveRecord::Migration
  def change
    add_reference :countries, :region, index: true
  end
end
