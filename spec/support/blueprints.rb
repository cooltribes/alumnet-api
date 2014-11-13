require 'machinist/active_record'
require 'faker'

User.blueprint do
  email { Faker::Internet.email }
  password { "12345678" }
  password_confirmation { "12345678" }
end

Profile.blueprint do
  first_name { Faker::Name.first_name }
  last_name { Faker::Name.last_name }
  avatar { File.open("#{Rails.root}/spec/fixtures/user_test.png") }
  born { Date.parse("21/08/1980") }
  register_step { 0 }
  user { User.make! }
end

Group.blueprint do
  name { "Group #{sn}"}
  description { Faker::Lorem.sentence }
  cover { File.open("#{Rails.root}/spec/fixtures/cover_test.jpg") }
  group_type { 0 }
end

Group.blueprint(:with_parent_and_childen) do
  name { "Group #{sn}"}
  description {  Faker::Lorem.sentence }
  cover { File.open("#{Rails.root}/spec/fixtures/cover_test.jpg") }
  group_type { 1 }
  parent { Group.make! }
  children { [Group.make!, Group.make!] }
end

Group.blueprint(:all_relations) do
  name { "Group #{sn}"}
  description {  Faker::Lorem.sentence }
  cover { File.open("#{Rails.root}/spec/fixtures/cover_test.jpg") }
  group_type { 1 }
  parent { Group.make! }
  children { [Group.make!, Group.make!] }
  posts(3)
end

Post.blueprint do
  body { Faker::Lorem.paragraph }
  user { User.make! }
end

Comment.blueprint do
  comment { Faker::Lorem.paragraph }
  user { User.make! }
end

Like.blueprint do
  user { User.make! }
end

Friendship.blueprint(:accepted) do
  user { User.make! }
  friend { User.make! }
  accepted { true }
end

Friendship.blueprint(:not_accepted) do
  user { User.make! }
  friend { User.make! }
  accepted { false }
end

Country.blueprint do
  cc_fips { sn }
  cc_iso { sn }
  tld { '.xx' }
  name { "Country #{sn}"}
  3.times { |x| City.make!(cc_fips: object.cc_fips, name: "City #{x} of #{object.name}") }
end

City.blueprint do
  cc_fips { sn }
  name { "City #{sn}" }
end