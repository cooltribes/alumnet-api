class Notification

  def self.notify_invitation_to_users(users, group)
    recipients = users.is_a?(Array) ? users : [users]
    Mailboxer::Notification.notify_all(
      recipients,
      "You have received an invitation to join the group #{group.name}!",
      "Greetings! You've been invited to join the group #{group.name}"
    )
  end

  def self.notify_join_to_users(users, group)
    recipients = users.is_a?(Array) ? users : [users]
    Mailboxer::Notification.notify_all(
      recipients,
      "You've joined to #{group.name}!",
      "Greetings! You've joined to #{group.name}"
    )
  end

  def self.notify_invitation_to_admins(admins, user, group)
    recipients = users.is_a?(Array) ? users : [users]
    MailBoxer::Notification.notify_all(
      recipients,
      "An invitation to join the group #{group.name} was sent!",
      "Greetings! An invitation to join the group #{group.name} was sent to user #{user.name}"
    )
  end
end