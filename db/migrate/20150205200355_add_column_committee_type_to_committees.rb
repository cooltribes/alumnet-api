class AddColumnCommitteeTypeToCommittees < ActiveRecord::Migration
  def change
    add_column :committees, :committee_type, :string
  end
end
