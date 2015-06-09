class AddPointsToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :points, :integer, default: 0
  end
end
