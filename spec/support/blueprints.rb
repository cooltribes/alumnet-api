require 'machinist/active_record'
require 'faker'

User.blueprint do
  email { Faker::Internet.email }
  name { Faker::Name.name }
  avatar { File.open("#{Rails.root}/spec/fixtures/user_test.png") }
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
  group_type { 1 }
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
