class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      
      t.string :name
      t.string :logo
      t.references :profile, index: true

    end
  end
end
