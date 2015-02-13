class AddColumnCommitteeIdToExperiences < ActiveRecord::Migration
  def change
  	add_column :experiences, :committee_id, :integer
    add_index :experiences, :committee_id
  end
end
