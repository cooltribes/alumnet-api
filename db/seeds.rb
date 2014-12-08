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

