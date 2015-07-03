class NotificationDetail < ActiveRecord::Base
  ### Relations
  belongs_to :mailboxer_notification
  belongs_to :sender, class_name: "User"

  ### Class methods
  def self.friendship_request(notification, sender)
    create!(url: "friends", notification_type: "friendship", sender: sender,
      mailboxer_notification_id: notification.id)
  end

  def self.friendship_accepted(notification, sender)
    create!(url: "users/#{sender.id}/posts", notification_type: "friendship", sender: sender,
      mailboxer_notification_id: notification.id)
  end

  def self.join_group(notification, sender, group)
    create!(url: "groups/#{group.id}/posts", notification_type: "group", sender: sender,
      mailboxer_notification_id: notification.id)
  end

  def self.join_group_admins(notification, sender, group)
    create!(url: "users/#{sender.id}/posts", notification_type: "group", sender: sender,
      mailboxer_notification_id: notification.id)
  end

  def self.invitation_to_event(notification, sender, event)
    create!(url: "events/#{event.id}/posts", notification_type: "event", sender: sender,
      mailboxer_notification_id: notification.id)
  end
end
