class NotificationDetail < ActiveRecord::Base
  ### Relations
  belongs_to :mailboxer_notification, class_name: "Mailboxer::Notification"
  belongs_to :sender, class_name: "User"

  ### Class methods
  def self.friendship_request(notification, sender)
    create!(url: "alumni/received", notification_type: "friendship", sender: sender,
      mailboxer_notification_id: notification.id, notified_object_id: sender.id)
  end

  def self.friendship_accepted(notification, sender)
    create!(url: "users/#{sender.id}/posts", notification_type: "friendship", sender: sender,
      mailboxer_notification_id: notification.id, notified_object_id: sender.id)
  end

  def self.join_group(notification, sender, group)
    create!(url: "groups/#{group.id}/posts", notification_type: "group", sender: sender,
      mailboxer_notification_id: notification.id, notified_object_id: group.id)
  end

  def self.join_group_approval_request(notification, sender, group)
    create!(url: "groups/#{group.id}/members", notification_type: "group", sender: sender,
      mailboxer_notification_id: notification.id, notified_object_id: group.id)
  end
  def self.join_group_admins(notification, sender, group)
    create!(url: "users/#{sender.id}/posts", notification_type: "group", sender: sender,
      mailboxer_notification_id: notification.id, notified_object_id: group.id)
  end

  def self.invitation_to_event(notification, sender, event)
    create!(url: "events/#{event.id}/posts", notification_type: "event", sender: sender,
      mailboxer_notification_id: notification.id, notified_object_id: event.id)
  end

  def self.notify_new_post(notification, post)
    create!(url: post.url_for_notification, notification_type: "post", sender: post.user,
      mailboxer_notification_id: notification.id, notified_object_id: post.id)
  end

  def self.notify_like(notification, sender, likeable)
    url = if likeable.is_a?(Post) || likeable.is_a?(Picture)
      likeable.url_for_notification
    elsif likeable.is_a?(Comment)
      likeable.commentable.url_for_notification
    end
    create!(url: url, notification_type: "like", sender: sender,
      mailboxer_notification_id: notification.id, notified_object_id: likeable.id)
  end

  def self.notify_comment_in_post(notification, sender, post)
    create!(url: post.url_for_notification, notification_type: "comment", sender: sender,
      mailboxer_notification_id: notification.id, notified_object_id: post.id)
  end

  def self.notify_tag(notification, sender, taggable)
    url = if taggable.is_a?(Post) || taggable.is_a?(Picture)
      taggable.url_for_notification
    elsif taggable.is_a?(Comment)
      taggable.commentable.url_for_notification
    else
      "no url"
    end
    create!(url: url, notification_type: "tag", sender: sender,
      mailboxer_notification_id: notification.id, notified_object_id: taggable.id)
  end

  def self.notify_approval_request_to_admins(notification, user)
    create!(url: "admin/users/#{user.id}", notification_type: "approval", sender: user,
      mailboxer_notification_id: notification.id, notified_object_id: user.id)
  end

  def self.notify_approval_request_to_user(notification, user)
    create!(url: "alumni/approval", notification_type: "approval", sender: user,
      mailboxer_notification_id: notification.id, notified_object_id: user.id)
  end

  def self.notify_admin_request_to_company_admins(notification, user, company)
    create!(url: "companies/#{company.id}/employees", notification_type: "approval", sender: user,
      mailboxer_notification_id: notification.id, notified_object_id: company.id)
  end
  def self.notify_new_company_admin(notification, user, company)
    create!(url: "companies/#{company.id}/about", notification_type: "approval", sender: user,
      mailboxer_notification_id: notification.id, notified_object_id: company.id)
  end
end
