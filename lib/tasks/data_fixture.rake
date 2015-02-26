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

  desc "create first privacy actions"
  task privacy_actions: :environment do
    require 'machinist'
    require Rails.root.join("spec/support/blueprints")
    PrivacyAction.make!(name: "see-name", description: "Who can see my name")
    PrivacyAction.make!(name: "see-avatar", description: "Who can see my profile picture")
    PrivacyAction.make!(name: "see-birthdate", description: "Who can see my Birth date")
    PrivacyAction.make!(name: "see-friends", description: "Who can see the list of my friends")
    PrivacyAction.make!(name: "see-job", description: "Who can see my current job position")
    PrivacyAction.make!(name: "see-born", description: "Who can see my city/country of origin")
    PrivacyAction.make!(name: "see-residence", description: "Who can see my city/country of residence")
  end
end