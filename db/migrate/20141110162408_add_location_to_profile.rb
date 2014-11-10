class AddLocationToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :birth_city, :integer
    add_column :profiles, :residence_city, :integer
  end
end
