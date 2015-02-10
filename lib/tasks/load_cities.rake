require 'rake'
namespace :db do
  desc "load cities from csv file"
  task load_cities: :environment do
    RAILS_ENV ||= 'staging'
    sql_file_path = "#{Rails.root}/db/data/copy_cities.sql"
    csv_file_path = "#{Rails.root}/db/data/GEODATASOURCE-CITIES-FREE.TXT"
    db_config = ActiveRecord::Base.configurations[RAILS_ENV]
    system "psql -h #{db_config['host']} -U #{db_config['username']} -W #{db_config['database']} -f #{sql_file_path}"
  end
end