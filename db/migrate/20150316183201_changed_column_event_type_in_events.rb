class ChangedColumnEventTypeInEvents < ActiveRecord::Migration
  def change
    remove_column :events, :event_type
    add_column :events, :event_type, :integer, default: 0
  end
end
