class AdminMailer < ActionMailer::Base
  default from: "alumnet-noreply@aiesec-alumni.org"
  layout "admin_mailer"

  def user_was_joined(admin, user, group)
    @user = user
    @group = group
    @admin = admin
    mail to: admin.email, subject: "#{user.name} joined the group #{group.name}"
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

  def match_task_business_exchange(user, task)
    @user = user
    @task = task
    mail to: user.email, subject: "A #{task.type_text} from #{task.company.name} matches with your profile"
  end

  def match_task_job_exchange(user, task)
    @user = user
    @task = task
    mail to: user.email, subject: "A #{task.type_text} from #{task.company.name} matches with your profile"
  end

  def match_task_meetup_exchange(user, task)
    @user = user
    @task = task
    mail to: user.email, subject: "A #{task.type_text} matches with your profile"
  end

  def admin_request_to_company_admins(admin, user, company)
    @user = user
    @admin = admin
    @company = company
    mail to: admin.email, subject: "#{user.name} requested admin rights in your company #{company.name}"
  end
end
