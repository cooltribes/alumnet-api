class CreateExperiences < ActiveRecord::Migration
  def change
    create_table :experiences do |t|
      t.integer :type
      t.string :name
      t.string :description
      t.date :start_date
      t.date :end_date
      t.string :organization_name
      t.references :city, index: true
      t.references :country, index: true
      t.integer :internship

      t.timestamps
    end
  end
end
