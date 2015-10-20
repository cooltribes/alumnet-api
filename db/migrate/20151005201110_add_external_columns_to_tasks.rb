class AddExternalColumnsToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :application_type, :integer, default: 0
    add_column :tasks, :external_url, :string
  end
end
