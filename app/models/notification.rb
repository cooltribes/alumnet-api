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
    return if users.blank?
    notification = new(users)
    if users == sender
      subject = "You've joined the #{group.name} group!"
      body = "Welcome! You've joined the #{group.name} group"
    else
      subject = "#{sender.name} added you to the #{group.name} group!"
      body = "Welcome! #{sender.name} added you to the #{group.mode} group #{group.name}"
    end
    notfy = notification.send_notification(subject, body)
    notification.send_pusher_notification
    NotificationDetail.join_group(notfy, sender, group)
    notification.recipients.each do |user|
      UserMailer.join_to_group(user, sender, group).deliver_later
    end
  end

  def self.notify_join_to_admins(admins, user, group)
    return if admins.blank?
    notification = new(admins)
    subject = "A new user was invited to join the group #{group.name}"
    body = "Was invited to join the group #{group.name}"
    notfy = notification.send_notification(subject, body)
    notification.send_pusher_notification
    NotificationDetail.join_group_admins(notfy, user, group)
    notification.recipients.each do |admin|
      AdminMailer.user_was_joined(admin, user, group).deliver_later
    end
  end

  def self.notify_group_join_accepted_to_user(user, group)
    return if user.blank?
    notification = new(user)
    subject = "You were accepted to join the group #{group.name}"
    body = "Your request to join the group #{group.name} was accepted"
    notfy = notification.send_notification(subject, body)
    notification.send_pusher_notification
    NotificationDetail.join_group(notfy, user, group)
    notification.recipients.each do |admin|
      UserMailer.user_was_accepted_in_group(user, group).deliver_later
    end
  end

  def self.notify_request_to_users(users, group, sender)
    return if users.blank?
    notification = new(users)
    if users == sender
      subject = "Your request was sent"
      body = "Your request to join group #{group.name} was sent."
    else
      subject = "#{sender.name} added you to the #{group.name} group!"
      body = "Welcome! #{sender.name} wants you to join the #{group.name} group, the request was sent."
    end
    notfy = notification.send_notification(subject, body)
    notification.send_pusher_notification
    NotificationDetail.join_group(notfy, sender, group)
  end

  def self.notify_request_to_admins(admins, user, group)
    return if admins.blank?
    notification = new(admins)
    subject = "A new user request to join the group #{group.name}"
    body = "Sent a request to join the group #{group.name}"
    notfy = notification.send_notification(subject, body)
    notification.send_pusher_notification
    NotificationDetail.join_group_approval_request(notfy, user, group)
    notification.recipients.each do |admin|
     AdminMailer.user_request_to_join(admin, user, group).deliver_later
    end
  end

  def self.notify_friendship_request_to_user(user, friend)
    return if user.blank? && friend.blank?
    notification = new(friend)
    subject = "New friendship request"
    body = "Sent you a friendship request on AlumNet."
    notfy = notification.send_notification(subject, body)
    notification.send_pusher_notification
    NotificationDetail.friendship_request(notfy, user)
    UserMailer.user_request_friendship(user, friend).deliver_later
  end

  def self.notify_accepted_friendship_to_user(user, friend)
    return if user.blank? && friend.blank?
    notification = new(user)
    subject = "You have a new friend!"
    body = "Your friend accepted your invitation to connect."
    notfy = notification.send_notification(subject, body)
    notification.send_pusher_notification
    NotificationDetail.friendship_accepted(notfy, friend)
    UserMailer.friend_accept_friendship(user, friend).deliver_later
  end

  def self.notify_invitation_event_to_user(attendance, host = nil)
    return if attendance.blank?
    event = attendance.event
    host_name = host ? host.name : event.creator.name
    notification = new(attendance.user)
    subject = "You have a new invitation to an event in AlumNet!",
    body = "Is inviting you to attend the event #{event.name}"
    notfy = notification.send_notification(subject, body)
    notification.send_pusher_notification
    NotificationDetail.invitation_to_event(notfy, event.creator, event)
    UserMailer.invitation_to_event(attendance.user, event).deliver_later
  end

  def self.notify_new_friendship_by_approval(requester, user)
    return if requester.blank? && user.blank?
    #to requester
    notfy_to_requester = new(requester)
    notfy1 = notfy_to_requester.send_notification("You have a new friend!",
      "#{user.permit_name(requester)} is now your friend.")
    notfy_to_requester.send_pusher_notification
    NotificationDetail.friendship_accepted(notfy1, requester)

    #to user
    notfy_to_user = new(user)
    notfy2 = notfy_to_user.send_notification("You have a new friend!",
      "#{requester.permit_name(user)} is now your friend.")
    notfy_to_user.send_pusher_notification
    NotificationDetail.friendship_accepted(notfy2, user)

    UserMailer.approval_request_accepted(requester, user).deliver_now
  end

  def self.notify_approval_request_to_admins(admins, user)
    return if admins.blank?
    notification = new(admins)
    subject = "hi Admin! A new user was registered in AlumNet"
    body = "Is waiting for your approval in admin section"
    notfy = notification.send_notification(subject, body)
    notification.send_pusher_notification
    notification.recipients.each do |admin|
      AdminMailer.user_request_approval(admin, user).deliver_later
    end
    NotificationDetail.notify_approval_request_to_admins(notfy, user)
  end

  def self.notify_approval_request_to_user(user, approver)
    return if user.blank? && approver.blank?
    notification = new(approver)
    subject = "#{user.name} wants to be approved in AlumNet"
    body = "Hello, I'm registering in Alumnet. Please approve my membership"
    notfy = notification.send_notification(subject, body)
    notification.send_pusher_notification()
    notification.recipients.each do |recipient|
      UserMailer.user_request_approval(recipient, user).deliver_later
    end
    NotificationDetail.notify_approval_request_to_user(notfy, user)
  end

  def self.notify_new_post(users, post)
    return if users.blank?
    notification = new(users)
    subject = "The #{post.postable.class.to_s} #{post.postable.name} has new post"
    body = "Posted in #{post.postable.class.to_s} #{post.postable.name}"
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
    subject = "#{like.user.name} likes your #{likeable.class.to_s}"
    body = "Likes your #{likeable.class.to_s}"
    notfy = notification.send_notification(subject, body)
    notification.send_pusher_notification
    NotificationDetail.notify_like(notfy, like.user, likeable)
  end

  def self.notify_comment_in_post_to_author(author, comment, post)
    return if author.blank?
    notification = new(author)
    subject = "You have new comment in Post"
    body = "Commented in your post"
    notfy = notification.send_notification(subject, body)
    notification.send_pusher_notification
    NotificationDetail.notify_comment_in_post(notfy, comment.user, post)
  end

  def self.notify_comment_in_post_to_users(users, comment, post)
    return if users.blank?
    notification = new(users)
    subject = "You have new comment in Post"
    body = "Commented in a post where you comment"
    notfy = notification.send_notification(subject, body)
    notification.send_pusher_notification
    NotificationDetail.notify_comment_in_post(notfy, comment.user, post)
  end

  def self.notify_tagging(tagging)
    notification = new(tagging.user)
    subject = "You were tagged"
    body = "Tagged you in a #{tagging.taggable_type}"
    notfy = notification.send_notification(subject, body)
    notification.send_pusher_notification
    NotificationDetail.notify_tag(notfy, tagging.tagger, tagging.taggable)
  end

  #When users ask admin rights for a company
  def self.notify_admin_request_to_company_admins(admins, user, company)
    return if admins.blank?
    notification = new(admins)
    subject = "Hi Admin! A new user has requested admin rights in #{company.name}"
    body = "Requested admin rights in #{company.name}"
    notfy = notification.send_notification(subject, body)
    notification.send_pusher_notification
    notification.recipients.each do |admin|
      AdminMailer.admin_request_to_company_admins(admin, user).deliver_later
    end
    NotificationDetail.notify_admin_request_to_company_admins(notfy, user, company)
  end

  def self.notify_new_company_admin(company_admin)
    return if company_admin.user.blank?
    user = company_admin.user
    company = company_admin.company
    notification = new(user)
    subject = "Hi #{user.name}, now you are an admin in #{company.name}"
    body = "Congratulations, now you are an admin in #{company.name}"
    notfy = notification.send_notification(subject, body)
    notification.send_pusher_notification
    notification.recipients.each do |u|
      UserMailer.new_company_admin(u, company).deliver_later
    end
    NotificationDetail.notify_new_company_admin(notfy, user, company)
  end
end

