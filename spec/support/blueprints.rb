require 'machinist/active_record'
require 'faker'

User.blueprint do
  email { Faker::Internet.email }
  password { "12345678A" }
  password_confirmation { "12345678A" }
  profile { Profile.make! }
  status { 1 }
end

User.blueprint(:admin) do
  email { Faker::Internet.email }
  password { "12345678A" }
  password_confirmation { "12345678A" }
  role { User::ROLES[:system_admin] }
  profile { Profile.make! }
  status { 1 }
end

User.blueprint(:with_points) do
  email { Faker::Internet.email }
  password { "12345678A" }
  password_confirmation { "12345678A" }
  status { 1 }
  profile { Profile.make!(points: 500) }
end

OauthProvider.blueprint(:facebook) do
  provider { 'facebook' }
  uid { 'UIDFACEBOOK' }
  oauth_token { '' }
  user { User.make! }
end

OauthProvider.blueprint(:linkedin) do
  provider { 'linkedin' }
  uid { 'LINKEDINUID' }
  oauth_token { '' }
  user { User.make! }
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

Experience.blueprint do
  exp_type { 0 }
  name { "Experience #{sn}"}
  description { Faker::Lorem.sentence }
  start_date { Date.parse("01/08/2000") }
  end_date { Date.parse("01/08/2001") }
  organization_name { "Organization #{sn}" }
  internship { false }
  committee { Committee.make! }
  city { City.make! }
  country { Country.make! }
  profile { Profile.make! }
end

Experience.blueprint(:profesional) do
  exp_type { 3 }
  name { "Experience #{sn}"}
  description { Faker::Lorem.sentence }
  start_date { Date.parse("01/08/2000") }
  end_date { Date.parse("01/08/2001") }
  organization_name { "Organization #{sn}" }
  internship { false }
  committee { Committee.make! }
  city { City.make! }
  country { Country.make! }
  profile { Profile.make! }
  seniority { Seniority.make! }
end


Group.blueprint do
  name { "Group #{sn}"}
  description { Faker::Lorem.sentence }
  cover { File.open("#{Rails.root}/spec/fixtures/cover_test.jpg") }
  group_type { 0 }
  join_process { 0 }
  country { Country.make!(:simple) }
  city { City.make! }
  official { false }
end

Group.blueprint(:with_parent_and_childen) do
  name { "Group #{sn}"}
  description {  Faker::Lorem.sentence }
  cover { File.open("#{Rails.root}/spec/fixtures/cover_test.jpg") }
  group_type { 0 }
  country { Country.make! }
  city { object.country.cities.first }
  parent { Group.make! }
  children { [Group.make!, Group.make!] }
  join_process { 0 }
  official { false }
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
  official { false }
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
  postable { User.make! }
end

Comment.blueprint do
  comment { Faker::Lorem.paragraph }
  user { User.make! }
end

Like.blueprint do
  user { User.make! }
end

Friendship.blueprint(:accepted) do
  user { User.make!(status: 1) }
  friend { User.make!(status: 1) }
  accepted { true }
end

Friendship.blueprint(:not_accepted) do
  user { User.make! }
  friend { User.make! }
  accepted { false }
end

Region.blueprint do
  name { "Region #{sn}" }
end

Country.blueprint(:simple) do
  cc_fips { sn }
  cc_iso { sn }
  tld { '.xx' }
  aiesec { false }
  name { "Country #{sn}"}
end

Country.blueprint do
  cc_fips { sn }
  cc_iso { sn }
  tld { '.xx' }
  name { "Country #{sn}"}
  aiesec { false }
  3.times { |x| City.make!(cc_iso: object.cc_iso, name: "City #{x} of #{object.name}") }
  2.times { |x| Committee.make!(cc_fips: object.cc_fips, name: "Committee #{x} of #{object.name}",
    committee_type: "National") }
  3.times { |x| Committee.make!(cc_fips: object.cc_fips, name: "Committee #{x} of #{object.name}",
    committee_type: "Local") }
end

Country.blueprint(:with_local_committee) do
  cc_fips { sn }
  cc_iso { sn }
  tld { '.xx' }
  name { "Country #{sn}"}
  aiesec { false }
  3.times { |x| City.make!(cc_iso: object.cc_iso, name: "City #{x} of #{object.name}") }
  3.times { |x| Committee.make!(cc_fips: object.cc_fips, name: "Committee #{x} of #{object.name}",
    committee_type: "Local") }
end

Country.blueprint(:with_national_committee) do
  cc_fips { sn }
  cc_iso { sn }
  tld { '.xx' }
  name { "Country #{sn}"}
  aiesec { false }
  3.times { |x| City.make!(cc_iso: object.cc_iso, name: "City #{x} of #{object.name}") }
  3.times { |x| Committee.make!(cc_fips: object.cc_fips, name: "Committee #{x} of #{object.name}",
    committee_type: "National") }
end


City.blueprint do
  cc_iso { sn }
  name { "City #{sn}" }
end

Committee.blueprint do
  cc_fips { sn }
  name { "Committee #{sn}" }
  committee_type { "Local" }
end

Language.blueprint do
  name { "Language #{sn}"}
end

Skill.blueprint do
  name { "Skill #{sn}"}
end

ContactInfo.blueprint(:email) do
  contact_type { 0 }
  info { Faker::Internet.email }
  privacy { 1 }
  contactable { Profile.make! }
end

PrivacyAction.blueprint do
  name { "see-name" }
  description { "This is a description" }
end

Privacy.blueprint do
  user { User.make! }
  privacy_action { PrivacyAction.make! }
  value { 1 }
end

Event.blueprint do
  name { "Event #{sn}"}
  description { Faker::Lorem.sentence }
  cover { File.open("#{Rails.root}/spec/fixtures/cover_test.jpg") }
  event_type { 0 }
  country { Country.make! }
  city { object.country.cities.first }
  address { Faker::Address.street_address }
  start_date { Date.today }
  end_date { Date.today + 20 }
  start_hour { "8:00" }
  end_hour { "16:30" }
  capacity { 20 }
  creator { User.make }
end

Attendance.blueprint do
  status { 'going' }
  event { Event.make! }
  user { User.make! }
end

Picture.blueprint do
  title { "Picture #{sn}"}
  picture { File.open("#{Rails.root}/spec/fixtures/cover_test.jpg") }
  date_taken { nil }
  uploader { User.make! }
end

Subscription.blueprint(:lifetime) do
  start_date { Date.today }
  end_date { nil }
  lifetime { true }
  status { 1 }
  ownership_type { 1 }
  user { User.make! }
  creator { User.make! }
end

Subscription.blueprint(:premium) do
  start_date { Date.today }
  end_date { Date.today + 365 }
  lifetime { false }
  status { 1 }
  ownership_type { 1 }
  user { User.make! }
  creator { User.make! }
end

Invitation.blueprint do
  user { User.make }
  guest_email { Faker::Internet.email }
end

Task.blueprint(:business) do
  name { "Testing #{sn}" }
  description { "testing task" }
  offer { Faker::Lorem.sentence }
  duration { "hours" }
  nice_have_list { "1638,1590,1636" }
  must_have_list { "1637,1606" }
  post_until { Date.today + 30 }
  help_type { "task_business_exchange" }
  country { Country.make! }
  city { object.country.cities.first }
  user {  User.make! }
end

Task.blueprint(:job) do
  name { "Testing #{sn}" }
  description { "testing task" }
  offer { Faker::Lorem.sentence }
  duration { "hours" }
  nice_have_list { "1638,1590,1636" }
  must_have_list { "1637,1606" }
  post_until { Date.today + 30 }
  help_type { "task_job_exchange" }
  country { Country.make! }
  city { object.country.cities.first }
  user {  User.make! }
end

Task.blueprint(:home) do
  name { "Testing #{sn}" }
  description { "testing task" }
  offer { Faker::Lorem.sentence }
  duration { "hours" }
  nice_have_list { "1638,1590,1636" }
  must_have_list { "1637,1606" }
  post_until { Date.today + 30 }
  help_type { "task_home_exchange" }
  country { Country.make! }
  city { object.country.cities.first }
  user {  User.make! }
end

Task.blueprint(:meetup) do
  name { "Testing #{sn}" }
  description { "testing task" }
  offer { Faker::Lorem.sentence }
  duration { "hours" }
  nice_have_list { "1638,1590,1636" }
  must_have_list { "1637,1606" }
  post_until { Date.today + 30 }
  help_type { "task_meetup_exchange" }
  country { Country.make! }
  city { object.country.cities.first }
  user {  User.make! }
end

Action.blueprint do
  name { "Action #{sn}" }
  description { Faker::Lorem.sentence }
  status { 'active' }
  value { 50 }
end

UserAction.blueprint do
  user { User.make! }
  action { Action.make! }
  status { 'active' }
  value { action.value }
  generator_id { action.id }
  generator_type { action.name }
end

Prize.blueprint do
  name { "Prize #{sn}" }
  description { Faker::Lorem.sentence }
  status { 'active' }
  price { 50 }
  prize_type { 1 }
  quantity { 1 }
end

UserPrize.blueprint do
  user { User.make! }
  prize { Prize.make! }
  status { 'active' }
  # price { prize.price }
  # prize_type { prize.prize_type }
  # remaining_quantity { prize.quantity }
  price { 50 }
  prize_type { 1 }
  remaining_quantity { 1 }
end

Sector.blueprint do
  name { "Sector #{sn}" }
end

Product.blueprint do
  name { "Product #{sn}" }
  description { Faker::Lorem.sentence }
  status { 'active' }
  price { 100 }
  product_type { 1 }
  quantity { 1 }
  feature { 'subscription' }
end

UserProduct.blueprint do
  user { User.make! }
  product { Product.make! }
  status { 'active' }
  start_date { Date.current }
  end_date { Date.current+1.year }
  transaction_type { 1 }
end

Company.blueprint do
  name { "Company #{sn}"}
  description { Faker::Lorem.sentence }
  main_address { Faker::Address.street_address }
  size { 1 }
  logo { File.open("#{Rails.root}/spec/fixtures/cover_test.jpg") }
  sector { Sector.make! }
  country { Country.make! }
  city { City.make! }
  creator { User.make! }
  links(2)
end

Keyword.blueprint do
  name { "Keyword #{sn}" }
end

CompanyRelation.blueprint do
  company { Company.make! }
  profile { User.make!.profile }
  offer { "Ofrezco " + Faker::Lorem.sentence }
  search { "Busco " + Faker::Lorem.sentence }
  business_me { "Por que hacer negocios " + Faker::Lorem.sentence }
end

CompanyRelationKeyword.blueprint(:offer) do
  company_relation { CompanyRelation.make! }
  keyword { Keyword.make! }
  keyword_type { 0 }
end

CompanyRelationKeyword.blueprint(:search) do
  company_relation { CompanyRelation.make! }
  keyword { Keyword.make! }
  keyword_type { 1 }
end

TaskInvitation.blueprint do
  user { User.make! }
  task { Task.make!(:job) }
  accepted { false }
end

Folder.blueprint do
  name { "Folder #{sn}" }
  creator { User.make! }
end

Attachment.blueprint do
  name { "Attachment #{sn}" }
  file { File.open("#{Rails.root}/spec/fixtures/contacts.csv") }
  uploader { User.make! }
  folder { Folder.make! }
end

Link.blueprint do
  title { "Link #{sn}"}
  description { Faker::Lorem.sentence }
  url { Faker::Internet.url }
  linkable { }
end

Feature.blueprint do
  name { "Feature #{sn}" }
  description { Faker::Lorem.sentence }
  status { 'active' }
  key_name { 'some_key_name' }
end

EventPayment.blueprint do
  price { 1000 }
  reference { "XXXX-XXXX-#{sn}"}
  user { User.make! }
  event { Event.make! }
  attendance_id { Attendance.make! }
end

Payment.blueprint do
  subtotal { 900 }
  iva { 100 }
  total { 1000 }
  reference { "XXXX-XXXX-#{sn}"}
  user { User.make! }
  paymentable_id { Subscription.make!(:lifetime).id }
  paymentable_type { "Subscription" }
end

Seniority.blueprint do
  name { "Seniority #{sn}"}
  seniority_type { "Profesional" }
end

Branch.blueprint do
  address { Faker::Address.street_address }
  company { Company.make! }
end

ProductService.blueprint(:service) do
  name { "Service #{sn}"}
  service_type { 1 }
end

ProductService.blueprint(:product) do
  name { "Product #{sn}"}
  service_type { 2 }
end