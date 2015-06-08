class CreateCompanyRelations < ActiveRecord::Migration
  def change
    create_table :company_relations do |t|
      t.references :profile, index: true
      t.references :company, index: true   
      t.string :offer
      t.string :search
      t.string :business_me

      t.timestamps null: false
    end
  end
end
