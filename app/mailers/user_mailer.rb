class UserMailer < ActionMailer::Base
  default from: "alumnet@alumnet.com"

  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Password reset"
  end

  def join_to_group(user, group)
    @user = user
    @group = group
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
    mail to: @user.email, subject: "Yo have a new approved request"
  end

  def user_request_approval(approver, requester)
    @approver = approver
    @requester = requester
    mail to: @requester.email, subject: "#{requester.name} wants to be approved in AlumNet"
  end

end
