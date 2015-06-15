class AddColumEmploymentTypeAndPositionTypeToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :employment_type, :integer, default: 0
    add_column :tasks, :position_type, :integer, default: 0
  end
end
