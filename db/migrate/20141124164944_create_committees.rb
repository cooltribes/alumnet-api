class CreateCommittees < ActiveRecord::Migration
  def change
    create_table :committees do |t|
      t.string :cc_fips
      t.string :name

      t.timestamps
    end
    add_index :committees, :cc_fips
  end
end
