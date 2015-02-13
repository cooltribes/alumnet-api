class AddColumnRegionIdToExperiences < ActiveRecord::Migration
  def change
    add_reference :experiences, :region, index: true
  end
end
