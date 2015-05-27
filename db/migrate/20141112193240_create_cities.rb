class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.string :cc_fips, index: true
      t.string :name
    end
  end
end
