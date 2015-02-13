class AddColumnAiesecToCountries < ActiveRecord::Migration
  def change
    add_column :countries, :aiesec, :bool
  end
end
