require 'rake'
namespace :app do
  desc "create all privacy actions"
  task privacy_actions: :environment do
    PrivacyAction.find_or_create_by(name: "see-name", description: "Who can see my name")
    PrivacyAction.find_or_create_by(name: "see-avatar", description: "Who can see my profile picture")
    PrivacyAction.find_or_create_by(name: "see-birthdate", description: "Who can see my birth day and month")
    PrivacyAction.find_or_create_by(name: "see-birth-year", description: "Who can see my birth year")
    PrivacyAction.find_or_create_by(name: "see-friends", description: "Who can see the list of my friends")
    PrivacyAction.find_or_create_by(name: "see-job", description: "Who can see my current job position")
    PrivacyAction.find_or_create_by(name: "see-born", description: "Who can see my city/country of origin")
    PrivacyAction.find_or_create_by(name: "see-residence", description: "Who can see my city/country of residence")
  end

  desc "create all privacies to users"
  task create_privacies: :environment do
    User.all.each do |user|
      user.send(:create_privacies)
    end
  end
end