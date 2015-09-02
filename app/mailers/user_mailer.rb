class UserMailer < ActionMailer::Base
  default from: "alumnet-noreply@aiesec-alumni.org"

  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Password reset"
  end

  def join_to_group(user, sender, group)
    @user = user
    @group = group
    @sender = sender
    mail to: user.email, subject: "You've joined to the Group #{group.name}!"
  end

  def user_request_friendship(user, friend)
    @user = user
    @friend = friend
    mail to: friend.email, subject: "You have a new friendship request"
  end

  def friend_accept_friendship(user, friend)
    @user = user
    @friend = friend
    mail to: user.email, subject: "You have a new friend!"
  end

  def invitation_to_event(user, event)
    @user = user
    @event = event
    mail to: user.email, subject: "You have a new invitation!"
  end

  def approval_request_accepted(requester, approver)
    @approver = approver
    @user = requester
    mail to: @user.email, subject: "You have a new approved request"
  end

  def user_request_approval(approver, requester)
    @approver = approver
    @requester = requester
    mail to: @approver.email, subject: "#{requester.name} wants to be approved in AlumNet"
  end

  def invitation_to_alumnet(email, guest_name, user, token)
    @guest_name = guest_name
    @user = user
    @token = token
    mail to: email, subject: "Invitation to join to AlumNet"
  end

  def user_was_accepted_in_group(user, group)
    @user = user
    @group = group
    mail to: user.email, subject: "Your request to join the group #{group.name} was accepted"
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

end
