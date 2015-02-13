class RenameLocationColumnsOnProfile < ActiveRecord::Migration
  def change
    rename_column :profiles, :birth_country, :birth_country_id
    rename_column :profiles, :birth_city, :birth_city_id
    rename_column :profiles, :residence_country, :residence_country_id
    rename_column :profiles, :residence_city, :residence_city_id
  end
end
