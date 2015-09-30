class AddColumnCoverPositionToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :cover_position, :string
  end
end
