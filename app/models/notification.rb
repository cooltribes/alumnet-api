class Notification

  ###Membership Join
  def self.notify_join_to_users(users, group)
    recipients = users.is_a?(Array) ? users : [users]
    Mailboxer::Notification.notify_all(
      recipients,
      "You've joined to #{group.name}!",
      "Welcome! You've joined to #{group.name}"
    )
  end

  def self.notify_join_to_admins(admins, user, group)
    recipients = admins.is_a?(Array) ? admins : [admins]
    Mailboxer::Notification.notify_all(
      recipients,
      "A new user was join to the group #{group.name}",
      "The user #{user.name} was join to the group #{group.name}"
    )
  end

  def self.notify_request_to_users(users, group)
    recipients = users.is_a?(Array) ? users : [users]
    Mailboxer::Notification.notify_all(
      recipients,
      "Your request was sent",
      "Your request to join in group #{group.name} was sent."
    )
  end

  def self.notify_request_to_admins(admins, user, group)
    recipients = admins.is_a?(Array) ? admins : [admins]
    Mailboxer::Notification.notify_all(
      recipients,
      "A new user request to join in group #{group.name}",
      "The user #{user.name} was sent request to join in group #{group.name}"
    )
  end
end