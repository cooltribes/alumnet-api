class AddCoverPositionToGroups < ActiveRecord::Migration
  def change
  	    add_column :groups, :cover_position, :string
  end
end
