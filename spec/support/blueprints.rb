require 'machinist/active_record'
require 'faker'

User.blueprint do
  email { Faker::Internet.email }
  name { Faker::Name.name }
  avatar { File.open("#{Rails.root}/spec/fixtures/user_test.png") }
  password { "12345678" }
  password_confirmation { "12345678" }
end

Group.blueprint do
  name { "Group #{sn}"}
  description { Faker::Lorem.sentence }
  avatar { File.open("#{Rails.root}/spec/fixtures/avatar_test.jpg") }
  group_type { 1 }
end

Group.blueprint(:with_parent_and_childen) do
  name { "Group #{sn}"}
  description {  Faker::Lorem.sentence }
  avatar { File.open("#{Rails.root}/spec/fixtures/avatar_test.jpg") }
  group_type { 1 }
  parent { Group.make! }
  children { [Group.make!, Group.make!] }
end