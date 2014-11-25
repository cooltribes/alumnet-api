class ChangeColumnTypeToExperiences < ActiveRecord::Migration
  def change
    rename_column :experiences, :type, :exp_type

  end
end
