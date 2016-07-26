require 'rake'
namespace :admin_users do
  desc "send new users registration email digest"
  task new_registrations_digest: :environment do
    mailer = GeneralMailer.new
    User.admins.each do |admin|
      if admin.last_week_approval_notifications.count > 0
        mailer.new_users_digest(admin)
      end
    end
  end
end