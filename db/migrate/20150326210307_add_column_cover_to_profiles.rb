class AddColumnCoverToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :cover, :string
  end
end
