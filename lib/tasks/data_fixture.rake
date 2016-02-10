require 'rake'
namespace :data_fixture do

  desc "create five regions"
  task regions: :environment do
    require 'machinist'
    require Rails.root.join("spec/support/blueprints")
    5.times { Region.make! }
  end

  desc "create three countries"
  task countries: :environment do
    require 'machinist'
    require Rails.root.join("spec/support/blueprints")
    3.times do
      Country.make!(:with_local_committee)
    end
  end

  desc "create languages and skills to test"
  task languages_and_skills: :environment do
    require 'machinist'
    require Rails.root.join("spec/support/blueprints")
    10.times do
      Language.make!
      Skill.make!
    end
  end

  desc "create five cities to Venezuela"
  task cities: :environment do
    require 'machinist'
    require Rails.root.join("spec/support/blueprints")
    5.times { City.make!(cc_fips: "VE") }
  end
  
  desc "change expired user_subscriptions status and corresponding user member field"
  task check: :environment do
    User.where("member = 1 OR member = 2").each do |user|
      user.validate_subscription()
    end
  end

  desc "create active actions available to award user points"
  task actions: :environment do
    Action.create!(name: "User invite", description: "Points awarded when invited user registers on Alumnet", status: 1, value: 50, key_name: "accepted_invitation")
    Action.create!(name: "Approval request", description: "Points awarded when user accepts an approval request on Alumnet", status: 1, value: 10, key_name: "request_approved")
  end

  desc "create initial premium features (disabled)"
  task features: :environment do
    Feature.create!(name: "Job Post", description: "Post a job is a member only feature", status: 0, key_name: "job_post")
    Feature.create!(name: "Apply for a job", description: "Apply for a job is a member only feature", status: 0, key_name: "apply_for_a_job")
    Feature.create!(name: "Get help", description: "Get help on business exchange is a member only feature", status: 0, key_name: "get_help")
    Feature.create!(name: "Give help", description: "Give help on business exchange is a member only feature", status: 0, key_name: "give_help")
  end

  desc "add contact_info for users registered after changes on registration process"
  task add_users_contact_info: :environment do
    Profile.includes(:contact_infos).where(contact_infos: { id: nil}).each do |profile|
      profile.contact_infos.create!(contact_type: 0, info: profile.user.email, privacy: 1, contactable_type: "Profile", contactable_id: profile.id)
      puts 'Contact info created for: ' + profile.user.name + ' | email: ' + profile.user.email
    end
  end
end