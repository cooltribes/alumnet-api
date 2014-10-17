require 'rake'
namespace :data_fixture do

  desc "create 10 groups to test an interfaces on development"
  task groups: :environment do
    require 'machinist'
    require Rails.root.join("spec/support/blueprints")
    10.times { Group.make!(:with_parent_and_childen) }
  end

  desc "create 4 users to test an interfaces on development"
  task users: :environment do
    require 'machinist'
    require Rails.root.join("spec/support/blueprints")
    4.times { User.make! }
  end
end