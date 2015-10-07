class AddCoverPositionToEvents < ActiveRecord::Migration
  def change
  	  	add_column :events, :cover_position, :string
  end
end
