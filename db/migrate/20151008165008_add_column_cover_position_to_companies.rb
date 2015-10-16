class AddColumnCoverPositionToCompanies < ActiveRecord::Migration
  def change
  	add_column :companies, :cover_position, :string
  end
end
