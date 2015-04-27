require 'rake'
namespace :subscriptions do
  desc "change expired user_subscriptions status and corresponding user member field"
  task validate_users_membership: :environment do
    User.where("member = 1 OR member = 2").each do |user|
      user.validate_subscription()
    end
  end
end