class AddColumnFormattedDescriptionToTask < ActiveRecord::Migration
  def change
    change_column :tasks, :description, :text
    add_column :tasks, :formatted_description, :text
  end
end
