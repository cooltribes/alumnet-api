class AddColumnArrivalDateToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :arrival_date, :date
  end
end
