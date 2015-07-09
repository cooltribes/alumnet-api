class CreateNotificationDetails < ActiveRecord::Migration
  def change
    create_table :notification_details do |t|
      t.string :url
      t.string :notification_type
      t.integer :mailboxer_notification_id, index: true
      t.integer :sender_id, index: true

      t.timestamps null: false
    end
  end
end
