require 'machinist/active_record'
require 'faker'

User.blueprint do
  email { Faker::Internet.email }
  password { "12345678" }
  password_confirmation { "12345678" }
  profile { Profile.make! }
end

User.blueprint(:admin) do
  email { Faker::Internet.email }
  password { "12345678" }
  password_confirmation { "12345678" }
  role { User::ROLES[:system_admin] }
  profile { Profile.make! }
end

Profile.blueprint do
  first_name { Faker::Name.first_name }
  last_name { Faker::Name.last_name }
  #avatar { File.open("#{Rails.root}/spec/fixtures/user_test.png") }
  gender { "M" }
  born { Date.parse("21/08/1980") }
  register_step { 0 }
  birth_country { Country.make! }
  birth_city { object.birth_country.cities.first }
  residence_country { Country.make! }
  residence_city { object.residence_country.cities.first }
end

Group.blueprint do
  name { "Group #{sn}"}
  description { Faker::Lorem.sentence }
  cover { File.open("#{Rails.root}/spec/fixtures/cover_test.jpg") }
  group_type { 0 }
  country { Country.make! }
  city { object.country.cities.first }
end

Group.blueprint(:with_parent_and_childen) do
  name { "Group #{sn}"}
  description {  Faker::Lorem.sentence }
  cover { File.open("#{Rails.root}/spec/fixtures/cover_test.jpg") }
  group_type { 1 }
  country { Country.make! }
  city { object.country.cities.first }
  parent { Group.make! }
  children { [Group.make!, Group.make!] }
end

Group.blueprint(:all_relations) do
  name { "Group #{sn}"}
  description {  Faker::Lorem.sentence }
  cover { File.open("#{Rails.root}/spec/fixtures/cover_test.jpg") }
  group_type { 1 }
  country { Country.make! }
  city { object.country.cities.first }
  parent { Group.make! }
  children { [Group.make!, Group.make!] }
  posts(3)
end

Membership.blueprint(:approved) do
  user { User.make! }
  group { Group.make! }
  approved { true }
end

Membership.blueprint(:not_approved) do
  user { User.make! }
  group { Group.make! }
  approved { false }
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
  3.times { |x| Committee.make!(cc_fips: object.cc_fips, name: "Committee #{x} of #{object.name}") }
end

City.blueprint do
  cc_fips { sn }
  name { "City #{sn}" }
end

Committee.blueprint do
  cc_fips { sn }
  name { "Committee #{sn}" }
end

Language.blueprint do
  name { "Language #{sn}"}
end

Skill.blueprint do
  name { "Skill #{sn}"}
end