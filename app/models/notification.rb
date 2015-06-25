class Notification
  attr_reader :recipients
  attr_reader :message

  #Param is the array or single object
  def initialize(recipients)
    @recipients = recipients.is_a?(Array) ? recipients : [recipients]
  end

  ### Instance Methods
  def send_notification(subject, body)
    receipts = Mailboxer::Notification.notify_all(recipients, subject, body)
    @message = receipts.is_a?(Array) ? receipts.first.notification : receipts.notification
  end

  def send_pusher_notification
    PusherDelegator.notifiy_new_notification(message, recipients)
  end

  ### Class Methods
  def self.notify_join_to_users(users, group)
    notification = new(users)
    subject = "You've joined to #{group.name}!"
    body = "Welcome! You've joined to #{group.name} group"
    notification.send_notification(subject, body)
    notification.send_pusher_notification
    notification.recipients.each do |user|
      UserMailer.user_was_accepted_in_group(user, group).deliver_later
    end
  end

  def self.notify_join_to_admins(admins, user, group)
    notification = new(admins)
    subject = "A new user was invited to join the group #{group.name}"
    body = "The user #{user.name} was invited to join the group #{group.name}"
    notification.send_notification(subject, body)
    notification.send_pusher_notification
    notification.recipients.each do |admin|
      AdminMailer.user_was_joined(admin, user, group).deliver_later
    end
  end

  def self.notify_group_join_accepted_to_user(user, group)
    notification = new(user)
    # subject = "Your request to join the group #{group.name} was accepted"
    # body = "The user #{user.name} was invited to join the group #{group.name}"
    # notification.send_notification(subject, body)
    # notification.send_pusher_notification
    notification.recipients.each do |admin|
      UserMailer.user_was_accepted_in_group(user, group).deliver_later
    end
  end


  def self.notify_group_user_added(user, group)  #User added to the group
    notification = new(user)
    subject = "The user #{user.name} added you to the group #{group.name}"
    body = "The user #{user.name} added you to the group #{group.name}"
    notification.recipients.each do |user|
      UserMailer.user_added_to_the_group(user, group).deliver_later
    end
  end

  def self.notify_request_to_users(users, group)
    notification = new(users)
    subject = "Your request was sent"
    body = "Your request to join in group #{group.name} was sent."
    notification.send_notification(subject, body)
    notification.send_pusher_notification
  end

  def self.notify_request_to_admins(admins, user, group)
    notification = new(admins)
    subject = "A new user request to join the group #{group.name}"
    body = "The user #{user.name} sent a request to join the group #{group.name}"
    notification.send_notification(subject, body)
    notification.send_pusher_notification
    notification.recipients.each do |admin|
     AdminMailer.user_request_to_join(admin, user, group).deliver_later
    end
  end

  def self.notify_friendship_request_to_user(user, friend)
    notification = new(friend)
    subject = "Hello, Do you like to be my Alumfriend?"
    body = "The user #{user.name} sent you a friendship request"
    notification.send_notification(subject, body)
    notification.send_pusher_notification
    UserMailer.user_request_friendship(user, friend).deliver_later
  end

  def self.notify_accepted_friendship_to_user(user, friend)
    notification = new(user)
    subject = "You have a new friend!"
    body = "Your friend #{friend.name} accepted your invitation to connect."
    notification.send_notification(subject, body)
    notification.send_pusher_notification
    UserMailer.friend_accept_friendship(user, friend).deliver_later
  end

  def self.notify_invitation_event_to_user(attendance)
    event = attendance.event
    notification = new(attendance.user)
    subject = "You have a new invitation to an event in AlumNet!",
    body = "The user #{event.creator.name} is inviting you to assist the event #{event.name}"
    notification.send_notification(subject, body)
    notification.send_pusher_notification
    UserMailer.invitation_to_event(attendance.user, event).deliver_later
  end

  def self.notify_new_friendship_by_approval(requester, user)
    #Notify about new friendship to requester
    recipients = [requester]
    notification = Mailboxer::Notification.notify_all(
      recipients,
      "You have a new friend!",
      user.permit_name(requester) + " is now your friend."
    )
    PusherDelegator.notifiy_new_notification(notification, recipients)

    recipients = [user]
    notification = Mailboxer::Notification.notify_all(
      recipients,
      "You have a new friend!",
      requester.permit_name(user) + " is now your friend."
    )
    PusherDelegator.notifiy_new_notification(notification, recipients)


    UserMailer.approval_request_accepted(requester, user).deliver_later
  end

  def self.notify_approval_request_to_admins(admins, user)

    notification = self.new(admins)
    subject = "A new user was registered in AlumNet"
    body = "The user #{user.name} is waiting for your approval"

    #Create and send notification
    message = notification.send_notification(subject, body)

    #Use pusher to notify recipients in real time
    notification.send_pusher_notification

    #Send Email
    notification.recipients.each do |admin|
      AdminMailer.user_request_approval(admin, user).deliver_later
    end
  end

  def self.notify_approval_request_to_user(user, approver)

    notification = self.new(approver)
    subject = "#{user.name} wants to be approved in AlumNet"
    body = "Hello, I'm registering in Alumnet. Please approve my membership"

    #Create and send notification
    message = notification.send_notification(subject, body)

    #Use pusher to notify recipients in real time
    notification.send_pusher_notification()
    #Send Email
    notification.recipients.each do |recipient|
      UserMailer.user_request_approval(recipient, user).deliver_later
    end
  end

end