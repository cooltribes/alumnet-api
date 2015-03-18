class Notification

  ###Membership Join
  def self.notify_join_to_users(users, group)
    recipients = users.is_a?(Array) ? users : [users]
    notification = Mailboxer::Notification.notify_all(
      recipients,
      "You've joined to #{group.name}!",
      "Welcome! You've joined to #{group.name}"
    )
    recipients.each do |user|
      UserMailer.join_to_group(user, group).deliver
    end
    PusherDelegator.notifiy_new_notification(notification, recipients)
  end

  def self.notify_join_to_admins(admins, user, group)
    recipients = admins.is_a?(Array) ? admins : [admins]
    notification = Mailboxer::Notification.notify_all(
      recipients,
      "A new user was join to the group #{group.name}",
      "The user #{user.name} was join to the group #{group.name}"
    )
    recipients.each do |admin|
      AdminMailer.user_was_joined(admin, user, group).deliver
    end
    PusherDelegator.notifiy_new_notification(notification, recipients)
  end

  def self.notify_request_to_users(users, group)
    recipients = users.is_a?(Array) ? users : [users]
    notification = Mailboxer::Notification.notify_all(
      recipients,
      "Your request was sent",
      "Your request to join in group #{group.name} was sent."
    )
    PusherDelegator.notifiy_new_notification(notification, recipients)
  end

  def self.notify_request_to_admins(admins, user, group)
    recipients = admins.is_a?(Array) ? admins : [admins]
    notification = Mailboxer::Notification.notify_all(
      recipients,
      "A new user request to join the group #{group.name}",
      "The user #{user.name} sent a request to join the group #{group.name}"
    )
    recipients.each do |admin|
      AdminMailer.user_request_to_join(admin, user, group).deliver
    end
    PusherDelegator.notifiy_new_notification(notification, recipients)
  end

  def self.notify_friendship_request_to_user(user, friend)
    recipients = [friend]
    notification = Mailboxer::Notification.notify_all(
      recipients,
      "You have a new friendship request",
      "The user #{user.name} sent you a friendship request"
    )
    UserMailer.user_request_friendship(user, friend).deliver
    PusherDelegator.notifiy_new_notification(notification, recipients)
  end

  def self.notify_accepted_friendship_to_user(user, friend)
    recipients = [user]
    notification = Mailboxer::Notification.notify_all(
      recipients,
      "You have a new friend!",
      "The user #{friend.name} has accepted your friendship request"
    )
    UserMailer.friend_accept_friendship(user, friend).deliver
    PusherDelegator.notifiy_new_notification(notification, recipients)
  end

  def self.notify_invitation_event_to_user(attendance)
    user = attendance.user
    event = attendance.event
    recipients = [user]
    notification = Mailboxer::Notification.notify_all(
      recipients,
      "You have a new invitation!",
      "The user #{event.creator.name} is inviting you to assist the event #{event.name}"
    )
    UserMailer.invitation_to_event(user, event).deliver
    PusherDelegator.notifiy_new_notification(notification, recipients)
  end
end