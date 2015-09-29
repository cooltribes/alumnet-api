class AdminMailer < ActionMailer::Base
  default from: "alumnet-noreply@aiesec-alumni.org"
  layout "admin_mailer"

  def user_was_joined(admin, user, group)
    @user = user
    @group = group
    @admin = admin
    mail to: admin.email, subject: "#{user.name} joined to the group #{group.name}"
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

  def user_have_match_in_task(user, task)
    @user = user
    @task = task
    mail to: user.email, subject: "You have a match in a task"
  end

  def admin_request_to_company_admins(admin, user)
    @user = user
    @admin = admin
    mail to: admin.email, subject: "A new user has requested admin rights in your company"
  end
end
