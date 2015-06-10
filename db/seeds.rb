require 'smarter_csv'

## THE CITIES MUST BE LOADED IN THE DATABASE DIRECTLY
## COPY cities (cc_fips, name) FROM 'path/to/GEODATASOURCE-CITIES-FREE.TXT' DELIMITER E'\t' ENCODING 'ISO-8859-5';

file = File.open('db/data/GEODATASOURCE-COUNTRY.TXT', "r:ISO-8859-5")
options = { key_mapping: {country_name: :name}, col_sep: "\t"}
SmarterCSV.process(file, options ) do |array|
  Country.create( array.first )
end
file.close

file = File.open('db/data/languages.csv', "r:ISO-8859-5")
options = { col_sep: "\t"}
SmarterCSV.process(file, options ) do |array|
  Language.create( array.first )
end
file.close

file = File.open('db/data/skills.csv', "r:ISO-8859-5")
options = { col_sep: "\t"}
SmarterCSV.process(file, options ) do |array|
  Skill.create( array.first )
end
file.close

file = File.open('db/data/committees.csv', "r:ISO-8859-5")
SmarterCSV.process(file) do |array|
  Committee.create( array.first )
end
file.close

file = File.open('db/data/regions.csv')
options = { col_sep: "\t"}
SmarterCSV.process(file, options ) do |array|
  Region.create( array.first )
end
file.close

file = File.open('db/data/sectors.csv')
options = { col_sep: "\t"}
SmarterCSV.process(file, options ) do |array|
  Sector.create( array.first )
end
file.close

### Data
venezuela = Country.find_by(name: "Venezuela")
belgium = Country.find_by(name: "Belgium")
english = Language.find_by(name: "English")
committee = Committee.find_by(name: "Europe")

### Initial admin
admin = User.create!(email: "alumnet@cooltribes.com", password: "AlumNet2015",
  password_confirmation: "AlumNet2015", role: "AlumNetAdmin")
profile = admin.profile
profile.attributes = { first_name: "AlumNet", last_name: "SuperAdmin", born: "1910-01-01",
  gender: "F", birth_country_id: venezuela.id, residence_country_id: belgium.id }
profile.save(validate: false)
profile.contact_infos.build(contact_type: 0, info: admin.email, privacy: 1)
profile.experiences.build(name: "AlumNet SuperAdmin", description: "AlumNet SuperAdmin",
  start_date: "1910-01-01", end_date: "1910-06-01", aiesec_experience: "International",
  country_id: belgium.id, committee_id: committee.id, exp_type: 0)
profile.skills << Skill.first
profile.language_levels << LanguageLevel.new(language_id: english.id, level: 5)
profile.skills!
admin.activate!

####Initial Groups
# alumnet = Group.create!(name: "AlumNet", description: "This is the official group of AlumNet",
#   group_type: 1, join_process: 2, creator_user_id: admin.id )
# international = Group.create!(name: "International", description: "This is the official group International",
#   group_type: 1, join_process: 2, creator_user_id: admin.id)