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
  
end