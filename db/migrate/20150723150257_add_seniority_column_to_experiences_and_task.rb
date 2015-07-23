class AddSeniorityColumnToExperiencesAndTask < ActiveRecord::Migration
  def change
    add_column :experiences, :seniority_id, :integer
    add_column :tasks, :seniority_id, :integer
    remove_column :tasks, :position_type
    add_index :experiences, :seniority_id
    add_index :tasks, :seniority_id
  end
end
