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

  desc "create 2 users and 2 groups, 1 user belongs to 1 group"
  task users_groups: :environment do
    require 'machinist'
    require Rails.root.join("spec/support/blueprints")
    user_a = User.make!
    user_b = User.make!
    group_a = Group.make!
    group_b = Group.make!
    Membership.create_membership_for_creator(group_a, user_a)
    Membership.create_membership_for_creator(group_b, user_b)
  end
end