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
    6.times { |x| User.make!(email: "user_#{x}@alumnet.com") }
    User.all.each do |user|
      user.profile.update(
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name,
        avatar: File.open("#{Rails.root}/spec/fixtures/user_test.png"),
        born: Date.parse("21/08/1980"),
        register_step: 1,
        gender: (rand(1) == 0) ? "M" : "F"
      )
    end
    me = User.make!(email: "fcoarmandomendoza@gmail.com", password: "210880", password_confirmation: "210880")
    me.profile.update(
      first_name: "Franciso Armando",
      last_name: "Mendoza Granda",
      avatar: File.open("#{Rails.root}/spec/fixtures/user_test.png"),
      born: Date.parse("21/08/1980"),
      register_step: 1,
      gender: "M"
    )
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

  desc "create all date to test group module"
  task group_data: :environment do
    require 'machinist'
    require Rails.root.join("spec/support/blueprints")
    user_a = User.make!(email: "fcoarmandomendoza@gmail.com", name: "Armando")
    user_b = User.make!
    user_c = User.make!
    group_a = Group.make!(creator_user_id: user_a.id)
    group_b = Group.make!(creator_user_id: user_b.id)
    group_c = Group.make!(creator_user_id: user_c.id)
    Membership.create_membership_for_creator(group_a, user_a)
    Membership.create_membership_for_creator(group_b, user_b)
    Membership.create_membership_for_creator(group_c, user_c)
    post = Post.make!(postable: group_a, user: user_a)
    Comment.make!(commentable: post, user: user_b)
    Comment.make!(commentable: post, user: user_c)
  end

  desc "create three countries"
  task countries: :environment do
    require 'machinist'
    require Rails.root.join("spec/support/blueprints")
    3.times { Country.make! }
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
end