require 'machinist/active_record'

User.blueprint do
  email { Faker::Internet.email }
  password { "12345678" }
  password_confirmation { "12345678" }
end

Group.blueprint do
  name { "Group #{sn}"}
  description { "Group description" }
  avatar { "Avatar" }
  group_type { 1 }
end

Group.blueprint(:with_parent_and_childen) do
  name { "Group #{sn}"}
  description { "Group description" }
  avatar { "Avatar" }
  group_type { 1 }
  parent { Group.make! }
  children { [Group.make!, Group.make!] }
end