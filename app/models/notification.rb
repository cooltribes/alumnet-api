class Notification
  attr_reader :recipients, :notification

  #Param is the array or single object
  def initialize(recipients)
    @recipients = recipients.is_a?(Array) ? recipients : [recipients]
  end

  ### Instance Methods
  def send_notification(subject, body, object = nil, sender = nil)
    receipts = Mailboxer::Notification.notify_all(recipients, subject,
      body, object, true, nil, false, sender)
    @notification = receipts.is_a?(Array) ? receipts.first.notification : receipts.notification
  end

  def send_pusher_notification
    PusherDelegator.send_notification(notification, recipients)
  end

  def send_gcm_notification
    GcmDelegator.send_notification(notification, recipients)
  end

  ### Class Methods
  # TODO: hacer review y refactor de preferences :yondry
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
    notfy = notification.send_notification(subject, body, group, sender)
    notification.send_pusher_notification
    NotificationDetail.join_group(notfy, sender, group)
    notification.recipients.each do |user|
      preference = user.email_preferences.find_by(name: 'join_group_invitation')
      if not(preference.present?) || (preference.present? && preference.value == 0)
        UserMailer.join_to_group(user, sender, group).deliver_later
      end
    end
  end

  def self.notify_join_to_admins(admins, sender, group)
    return if admins.blank?
    notification = new(admins)
    subject = "A new user was invited to join the group #{group.name}"
    body = "Was invited to join the group #{group.name}"
    notfy = notification.send_notification(subject, body, group, sender)
    notification.send_pusher_notification
    NotificationDetail.join_group_admins(notfy, sender, group)
    notification.recipients.each do |admin|
      AdminMailer.user_was_joined(admin, sender, group).deliver_later
    end
  end

  def self.notify_group_join_accepted_to_user(sender, group)
    return if sender.blank?
    notification = new(sender)
    subject = "You were accepted to join the group #{group.name}"
    body = "Your request to join the group #{group.name} was accepted"
    notfy = notification.send_notification(subject, body, group, sender)
    notification.send_pusher_notification
    NotificationDetail.join_group(notfy, sender, group)
    notification.recipients.each do |admin|
      UserMailer.user_was_accepted_in_group(sender, group).deliver_later
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
    notfy = notification.send_notification(subject, body, group, sender)
    notification.send_pusher_notification
    NotificationDetail.join_group(notfy, sender, group)
  end

  def self.notify_request_to_admins(admins, sender, group)
    return if admins.blank?
    notification = new(admins)
    subject = "A new user request to join the group #{group.name}"
    body = "Sent a request to join the group #{group.name}"
    notfy = notification.send_notification(subject, body)
    notification.send_pusher_notification
    NotificationDetail.join_group_approval_request(notfy, sender, group)
    notification.recipients.each do |admin|
      preference = admin.email_preferences.find_by(name: 'join_group_request')
      if not(preference.present?) || (preference.present? && preference.value == 0)
        AdminMailer.user_request_to_join(admin, sender, group).deliver_later
      end
    end
  end

  def self.notify_friendship_request_to_user(user, friend)
    return if user.blank? && friend.blank?
    notification = new(friend)
    subject = "New friendship request"
    body = "Sent you a friendship request on AlumNet."
    notfy = notification.send_notification(subject, body, friend, user)
    notification.send_pusher_notification
    NotificationDetail.friendship_request(notfy, user)
    preference = friend.email_preferences.find_by(name: 'friendship')
    if not(preference.present?) || (preference.present? && preference.value == 0)
      UserMailer.user_request_friendship(user, friend).deliver_later
    end
  end

  def self.notify_accepted_friendship_to_user(user, friend)
    return if user.blank? && friend.blank?
    notification = new(user)
    subject = "You have a new friend!"
    body = "Your friend accepted your invitation to connect."
    notfy = notification.send_notification(subject, body, user, friend)
    notification.send_pusher_notification
    NotificationDetail.friendship_accepted(notfy, friend)
    preference = user.email_preferences.find_by(name: 'friendship_accepted')
    if not(preference.present?) || (preference.present? && preference.value == 0)
      UserMailer.friend_accept_friendship(user, friend).deliver_later
    end
  end

  def self.notify_invitation_event_to_user(attendance, host = nil)
    return if attendance.blank?
    event = attendance.event
    # host_name = host ? host.name : event.creator.name
    notification = new(attendance.user)
    subject = "You have a new invitation to an event in AlumNet!",
    body = "Is inviting you to attend the event #{event.name}"
    notfy = notification.send_notification(subject, body, event, attendance.user)
    notification.send_pusher_notification
    NotificationDetail.invitation_to_event(notfy, event.creator, event)
    UserMailer.invitation_to_event(attendance.user, event).deliver_later
  end

  def self.notify_new_friendship_by_approval(requester, user)
    return if requester.blank? && user.blank?
    #to requester
    notfy_to_requester = new(requester)
    notfy1 = notfy_to_requester.send_notification("You have a new friend!",
      "Is now your friend.", requester, requester)
    notfy_to_requester.send_pusher_notification
    NotificationDetail.friendship_accepted(notfy1, user)

    #to user
    notfy_to_user = new(user)
    notfy2 = notfy_to_user.send_notification("You have a new friend!",
      "Is now your friend.", user, user)
    notfy_to_user.send_pusher_notification
    NotificationDetail.friendship_accepted(notfy2, requester)

    UserMailer.approval_request_accepted(requester, user).deliver_later
  end

  def self.notify_approval_request_to_admins(admins, user)
    return if admins.blank?
    notification = new(admins)
    subject = "hi Admin! A new user was registered in AlumNet"
    body = "Is waiting for your approval in admin section"
    notfy = notification.send_notification(subject, body, user, user)
    notification.send_pusher_notification
    notification.recipients.each do |admin|
      AdminMailer.user_request_approval(admin, user).deliver_later
    end
    NotificationDetail.notify_approval_request_to_admins(notfy, user)
  end

  def self.notify_approval_request_to_user(user, approver)
    return if user.blank? && approver.blank?
    notification = new(approver)
    subject = "#{user.name} requested your Alumni verification"
    body = "If you know this person, click here to give your approval"
    notfy = notification.send_notification(subject, body, approver, user)
    notification.send_pusher_notification()
    notification.recipients.each do |recipient|
      preference = recipient.email_preferences.find_by(name: 'approval')
      if not(preference.present?) || (preference.present? && preference.value == 0)
        UserMailer.user_request_approval(recipient, user).deliver_later
      end
    end
    NotificationDetail.notify_approval_request_to_user(notfy, user)
  end

  def self.notify_new_post(users, post)
    return if users.blank?
    notification = new(users)
    subject = "The #{post.postable.class.to_s} #{post.postable.name} has new post"
    body = "Posted in #{post.postable.class.to_s} #{post.postable.name}"
    notfy = notification.send_notification(subject, body, post, post.user)
    NotificationDetail.notify_new_post(notfy, post)
    notification.send_pusher_notification
    notification.send_gcm_notification
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
    notfy = notification.send_notification(subject, body, likeable, like.user)
    notification.send_pusher_notification
    NotificationDetail.notify_like(notfy, like.user, likeable)
  end

  def self.notify_comment_in_post_to_author(author, comment, post)
    return if author.blank?
    notification = new(author)
    subject = "You have new comment in Post"
    body = "Commented in your post"
    notfy = notification.send_notification(subject, body, post, comment.user)
    notification.send_pusher_notification
    NotificationDetail.notify_comment_in_post(notfy, comment.user, post)
  end

  def self.notify_comment_in_post_to_users(users, comment, post)
    return if users.blank?
    notification = new(users)
    subject = "You have new comment in Post"
    body = "Commented in a post where you comment"
    notfy = notification.send_notification(subject, body, post, comment.user)
    notification.send_pusher_notification
    NotificationDetail.notify_comment_in_post(notfy, comment.user, post)
  end

  def self.notify_tagging(tagging)
    notification = new(tagging.user)
    subject = "You were mentioned"
    body = "Mentioned you in a #{tagging.taggable_type}"
    notfy = notification.send_notification(subject, body, tagging.taggable, tagging.tagger)
    notification.send_pusher_notification
    NotificationDetail.notify_tag(notfy, tagging.tagger, tagging.taggable)
  end

  #When users ask admin rights for a company
  def self.notify_admin_request_to_company_admins(admins, user, company)
    return if admins.blank?
    notification = new(admins)
    subject = "Hi Admin! A new user has requested admin rights in #{company.name}"
    body = "Requested admin rights in #{company.name}"
    notfy = notification.send_notification(subject, body, company, user)
    notification.send_pusher_notification
    notification.recipients.each do |admin|
      AdminMailer.admin_request_to_company_admins(admin, user, company).deliver_later
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
    notfy = notification.send_notification(subject, body, company, user)
    notification.send_pusher_notification
    notification.recipients.each do |u|
      UserMailer.new_company_admin(u, company).deliver_later
    end
    NotificationDetail.notify_new_company_admin(notfy, user, company)
  end
end

