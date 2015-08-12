class Notification
  attr_reader :recipients, :message

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

  def self.notify_join_to_users(users, sender, group)
    notification = new(users)
    if users == sender
      subject = "You've joined the #{group.name} group!"
      body = "Welcome! You've joined the #{group.name} group"
    else
      subject = "#{sender.name} added you to the #{group.name} group!"
      body = "Welcome! the user #{sender.name} added you to the #{group.mode} group #{group.name}"
    end
    notfy = notification.send_notification(subject, body)
    notification.send_pusher_notification
    NotificationDetail.join_group(notfy, sender, group)
    notification.recipients.each do |user|
      UserMailer.join_to_group(user, sender, group).deliver_later
    end
  end

  def self.notify_join_to_admins(admins, user, group)
    notification = new(admins)
    subject = "A new user was invited to join the group #{group.name}"
    body = "The user #{user.name} was invited to join the group #{group.name}"
    notfy = notification.send_notification(subject, body)
    notification.send_pusher_notification
    NotificationDetail.join_group_admins(notfy, user, group)
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

  def self.notify_request_to_users(users, group, current_user)
    notification = new(users)
    if users == current_user
      subject = "Your request was sent"
      body = "Your request to join group #{group.name} was sent."
    else
      subject = "#{current_user.name} added you to the #{group.name} group!"
      body = "Welcome! #{current_user.name} wants you to join the #{group.name} group, the request was sent."
    end
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
    subject = "Hello, Do you like to be my Friend?"
    body = "The user #{user.name} sent you a friendship request"
    notfy = notification.send_notification(subject, body)
    notification.send_pusher_notification
    NotificationDetail.friendship_request(notfy, user)
    UserMailer.user_request_friendship(user, friend).deliver_later
  end

  def self.notify_accepted_friendship_to_user(user, friend)
    notification = new(user)
    subject = "You have a new friend!"
    body = "Your friend #{friend.name} accepted your invitation to connect."
    notfy = notification.send_notification(subject, body)
    notification.send_pusher_notification
    NotificationDetail.friendship_accepted(notfy, friend)
    UserMailer.friend_accept_friendship(user, friend).deliver_later
  end

  def self.notify_invitation_event_to_user(attendance)
    event = attendance.event
    notification = new(attendance.user)
    subject = "You have a new invitation to an event in AlumNet!",
    body = "The user #{event.creator.name} is inviting you to assist the event #{event.name}"
    notfy = notification.send_notification(subject, body)
    notification.send_pusher_notification
    NotificationDetail.invitation_to_event(notfy, event.creator, event)
    UserMailer.invitation_to_event(attendance.user, event).deliver_later
  end

  def self.notify_new_friendship_by_approval(requester, user)
    notfy_to_requester = new(requester)
    notfy_to_requester.send_notification("You have a new friend!",
      "#{user.permit_name(requester)} is now your friend.")
    notfy_to_requester.send_pusher_notification

    notfy_to_user = new(user)
    notfy_to_user.send_notification("You have a new friend!",
      "#{requester.permit_name(user)} is now your friend.")
    notfy_to_user.send_pusher_notification

    UserMailer.approval_request_accepted(requester, user).deliver_later
  end

  def self.notify_approval_request_to_admins(admins, user)
    notification = new(admins)
    subject = "A new user was registered in AlumNet"
    body = "The user #{user.name} is waiting for your approval"
    notification.send_notification(subject, body)
    notification.send_pusher_notification
    notification.recipients.each do |admin|
      AdminMailer.user_request_approval(admin, user).deliver_later
    end
  end

  def self.notify_approval_request_to_user(user, approver)
    notification = new(approver)
    subject = "#{user.name} wants to be approved in AlumNet"
    body = "Hello, I'm registering in Alumnet. Please approve my membership"
    notification.send_notification(subject, body)
    notification.send_pusher_notification()
    notification.recipients.each do |recipient|
      UserMailer.user_request_approval(recipient, user).deliver_later
    end
  end

  def self.notify_new_post(users, post)
    notification = new(users)
    subject = "The #{post.postable.class.to_s} #{post.postable.name} has new post"
    body = "Hello! the user #{post.user.name} posted in #{post.postable.class.to_s} #{post.postable.name}"
    notfy = notification.send_notification(subject, body)
    notification.send_pusher_notification
    NotificationDetail.notify_new_post(notfy, post)
  end

  def self.notify_like(like)
    likeable = like.likeable
    if like.likeable_type == "Post" || like.likeable_type == "Comment"
      return if likeable.user == like.user
      notification = new(likeable.user)
    elsif like.likeable_type == "Picture"
      return if likeable.uploader == like.user
      notification = new(likeable.uploader)
    end
    subject = "The user #{like.user.name} likes your #{likeable.class.to_s}"
    body = "The user #{like.user.name} likes your #{likeable.class.to_s}"
    notfy = notification.send_notification(subject, body)
    notification.send_pusher_notification
    NotificationDetail.notify_like(notfy, like.user, likeable)
  end

  def self.notify_comment_in_post_to_author(author, comment, post)
    notification = new(author)
    subject = "You have new comment in Post"
    body = "The user #{comment.user.name} commented in your post"
    notfy = notification.send_notification(subject, body)
    notification.send_pusher_notification
    NotificationDetail.notify_comment_in_post(notfy, comment.user, post)
  end

  def self.notify_comment_in_post_to_users(users, comment, post)
    notification = new(users)
    subject = "You have new comment in Post"
    body = "The user #{comment.user.name} commented in a post where you comment"
    notfy = notification.send_notification(subject, body)
    notification.send_pusher_notification
    NotificationDetail.notify_comment_in_post(notfy, comment.user, post)
  end
end