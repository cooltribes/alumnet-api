class RecreateCitiesTable < ActiveRecord::Migration
  def change
    drop_table :cities
    create_table :cities do |t|
      t.string :cc_iso, index: true
      t.string :name
    end
  end
end
