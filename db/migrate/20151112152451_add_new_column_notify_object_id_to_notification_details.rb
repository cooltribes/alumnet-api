class AddNewColumnNotifyObjectIdToNotificationDetails < ActiveRecord::Migration
  def change
    add_column :notification_details, :notified_object_id, :integer
  end
end
