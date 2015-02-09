class Notification

  ###Membership Join
  def self.notify_join_to_users(users, group)
    recipients = users.is_a?(Array) ? users : [users]
    Mailboxer::Notification.notify_all(
      recipients,
      "You've joined to #{group.name}!",
      "Welcome! You've joined to #{group.name}"
    )
    recipients.each do |user|
      UserMailer.join_to_group(user, group).deliver
    end
  end

  def self.notify_join_to_admins(admins, user, group)
    recipients = admins.is_a?(Array) ? admins : [admins]
    Mailboxer::Notification.notify_all(
      recipients,
      "A new user was join to the group #{group.name}",
      "The user #{user.name} was join to the group #{group.name}"
    )
    recipients.each do |admin|
      AdminMailer.user_was_joined(admin, user, group).deliver
    end
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
      "A new user request to join the group #{group.name}",
      "The user #{user.name} sent a request to join the group #{group.name}"
    )
    recipients.each do |admin|
      AdminMailer.user_request_to_join(admin, user, group).deliver
    end
  end

  def self.notify_friendship_request_to_user(user, friend)
    recipients = [friend]
    Mailboxer::Notification.notify_all(
      recipients,
      "You have a new friendship request",
      "The user #{user.name} sent you a friendship request"
    )
    UserMailer.user_request_friendship(user, friend).deliver
  end

  def self.notify_accepted_friendship_to_user(user, friend)
    recipients = [user]
    Mailboxer::Notification.notify_all(
      recipients,
      "You have a new friend!",
      "The user #{friend.name} has accepted your friendship request"
    )
    UserMailer.friend_accept_friendship(user, friend).deliver
  end
end