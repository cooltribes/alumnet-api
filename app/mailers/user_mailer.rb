class UserMailer < ActionMailer::Base
  default from: "alumnet-noreply@aiesec-alumni.org"

  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Password Reset"
  end

  def join_to_group(user, sender, group)
    @user = user
    @group = group
    @sender = sender
    mail to: user.email, subject: "You've joined the Group #{group.name}!"
  end

  def user_request_friendship(user, friend)
    @user = user
    @friend = friend
    mail to: friend.email, subject: "New friendship request from #{user.name}"
  end

  def friend_accept_friendship(user, friend)
    @user = user
    @friend = friend
    mail to: user.email, subject: "#{friend.name} accepted your friendship request"
  end

  def invitation_to_event(user, event, host)
    @user = user
    @event = event
    @host = host
    if host.present?
      mail to: user.email, subject: "#{host.profile.first_name} #{host.profile.last_name} invites you to the event #{event.name}"
    elsif
      mail to: user.email, subject: "You have a new invitation to an event in AlumNet!"
    end
  end

  def approval_request_accepted(requester, approver)
    @approver = approver
    @user = requester
    mail to: @user.email, subject: "#{approver.name} gave you an Alumni verification (#{@user.get_approved_requests.count}/3)"
  end

  def user_request_approval(approver, requester)
    @approver = approver
    @requester = requester
    mail to: @approver.email, subject: "Is #{requester.name} an AIESEC Alumni you know?"
  end

  def invitation_to_alumnet(email, guest_name, user, token)
    @guest_name = guest_name
    @user = user
    @token = token
    mail to: email, subject: "You’re invited to join AIESEC AlumNet."
  end

  def user_was_accepted_in_group(user, group)
    @user = user
    @group = group
    mail to: user.email, subject: "You are now a member of the #{group.name} group"
  end

  def user_applied_to_job(job_post, applicant, whyme)
    @user = job_post.user
    @applicant = applicant
    @job_post = job_post
    @whyme = whyme
    @avatar = if applicant.permit('see-avatar', @user)
      applicant.avatar.url
    else
      applicant.avatar.default_url
    end
    mail to: @user.email, subject: "#{applicant.name} applied to your job post #{job_post.name}"
  end

  def welcome(user)
    @user = user
    mail to: @user.email, subject: "Welcome to AlumNet! Your account has been approved"
  end

  def subscription_purchase(user_product)
    @user_product = user_product
    @user = user_product.user
    @product = user_product.product
    mail to: @user.email, subject: "You are now a premium member!"
  end

  def send_message_to_admin(to, user, message)
    @user = user
    @message = message
    mail to: to, subject: 'New message from contact form'
  end

  def new_company_admin(user, company)
    @user = user
    @company = company
    mail to: user, subject: "New admin rights in #{company.name}"
  end

  def meetup_apply(user, task)
    @user = user
    @task = task
    mail to: @task.user.email, subject: "#{user.name} wants to organize your meetup"
  end

  def ask_for_approval(user)
    @user = user
    mail to: @user.email, subject: "You need three approvals to complete AlumNet registration"
  end

  def new_message_direct(sender, user, message)
    @sender = sender
    @user = user
    mail to: @user.email, subject: "You have a new message from  #{sender.name}"
  end

  def user_edited_post_you_commented(user, post)
    @user = user
    @post = post
    mail to: @user.email, subject: "#{post.user.name} has edited a post you commented on"
  end
end
