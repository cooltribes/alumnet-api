class AddNewColumnsToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :description, :text
    add_column :companies, :main_address, :string
    add_column :companies, :size, :integer
    add_column :companies, :cover, :string
    add_column :companies, :country_id, :integer, index: true
    add_column :companies, :city_id, :integer, index: true
    add_column :companies, :sector_id, :integer, index: true
    add_column :companies, :creator_id, :integer, index: true
  end
end
