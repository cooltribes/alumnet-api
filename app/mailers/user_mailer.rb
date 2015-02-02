class UserMailer < ActionMailer::Base
  default from: "from@example.com"

  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Password reset"
  end

  def join_to_group(user, group)
    @user = user
    @group = group
    mail to: user.email, subject: "You've joined to the Group #{group.name}!"
  end
end
