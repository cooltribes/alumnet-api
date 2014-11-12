class CreateCountries < ActiveRecord::Migration
  def change
    create_table :countries do |t|
      t.string :cc_fips, index: true
      t.string :cc_iso
      t.string :tld
      t.string :name
    end
    add_index :countries, :cc_fips
  end
end
