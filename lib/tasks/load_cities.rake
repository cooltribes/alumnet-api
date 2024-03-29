require 'rake'
namespace :app do
  desc "load cities from csv file"
  task load_cities: :environment do
    ENV['RAILS_ENV'] ||= 'staging'
    sql_file_path = "#{Rails.root}/db/data/copy_cities.sql"
    csv_file_path = "#{Rails.root}/db/data/CITIES.CSV"
    system "cp #{csv_file_path} ~"
    db_config = ActiveRecord::Base.configurations[ENV['RAILS_ENV']]
    system "psql -h #{db_config['host']} -U #{db_config['username']} -W #{db_config['database']} -f #{sql_file_path}"
  end
end