require 'rake'
namespace :privacy_settings do
  desc "create all privacy actions"
  task privacy_actions: :environment do
    PrivacyAction.create!(name: "see-name", description: "Who can see my name")
    PrivacyAction.create!(name: "see-avatar", description: "Who can see my profile picture")
    PrivacyAction.create!(name: "see-birthdate", description: "Who can see my birth day and month")
    PrivacyAction.create!(name: "see-birth-year", description: "Who can see my birth year")
    PrivacyAction.create!(name: "see-friends", description: "Who can see the list of my friends")
    PrivacyAction.create!(name: "see-job", description: "Who can see my current job position")
    PrivacyAction.create!(name: "see-born", description: "Who can see my city/country of origin")
    PrivacyAction.create!(name: "see-residence", description: "Who can see my city/country of residence")
  end

  desc "create all privacies to users"
  task create_privacies: :environment do
    User.all.each do |user|
      user.send(:create_privacies)
    end
  end
end