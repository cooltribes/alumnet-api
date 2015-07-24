require 'rake'
namespace :app do
  desc "load data from given csv file to given database 'rake load_data_from_csv model=User file=db/data/file.csv'"
  task load_data_from_csv: :environment do
    model = ENV['model']
    file = ENV['file']
    if model && file
      file = File.open(file)
      options = { col_sep: ","}
      SmarterCSV.process(file, options) do |array|
        model.constantize.find_or_create_by( array.first )
      end
      file.close
    else
      puts "You must set model and file 'rake load_data_from_csv model=User file=db/data/file.csv'"
    end
  end
end