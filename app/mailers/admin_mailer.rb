class AdminMailer < ActionMailer::Base
  default from: "alumnet@alumnet.com"

  def user_was_joined(admin, user, group)
    @user = user
    @group = group
    @admin = admin
    mail to: admin.email, subject: "A new user was joined to the group #{group.name}"
  end

  def user_request_to_join(admin, user, group)
    @user = user
    @group = group
    @admin = admin
    mail to: admin.email, subject: "A new user request to join the group #{group.name}"
  end

  def user_request_approval(admin, user)
    @user = user
    @admin = admin
    mail to: admin.email, subject: "A new user was registered in AlumNet"
  end
end
