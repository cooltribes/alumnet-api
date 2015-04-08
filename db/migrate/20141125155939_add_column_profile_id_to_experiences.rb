class AddColumnProfileIdToExperiences < ActiveRecord::Migration
  def change
    add_column :experiences, :profile_id, :integer
    add_index :experiences, :profile_id
  end
end
