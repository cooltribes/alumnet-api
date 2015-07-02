class NotificationDetail < ActiveRecord::Base
  ### Relations
  belongs_to :mailboxer_notification
  belongs_to :subject, class_name: "User"

  ### Class methods
  def self.friendship_request(notification, user)
    create!(url: "friends/received", notification_type: "friendship", subject: user,
      mailboxer_notification_id: notification.id)
  end

  def self.friendship_accepted(notification, user)
    create!(url: "users/#{user.id}/posts", notification_type: "friendship", subject: user,
      mailboxer_notification_id: notification.id)
  end

  def self.join_group(notification, user, group)
    create!(url: "groups/#{group.id}/posts", notification_type: "group", subject: user,
      mailboxer_notification_id: notification.id)
  end

  def self.invitation_to_event(notification, user, event)
    create!(url: "events/#{event.id}/posts", notification_type: "event", subject: user,
      mailboxer_notification_id: notification.id)
  end
end
