class AddColumnsOfCountriesToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :birth_country, :integer
    add_column :profiles, :residence_country, :integer
  end
end
