class DropTableLanguagesProfiles < ActiveRecord::Migration
  def change
    drop_table :languages_profiles
  end
end
