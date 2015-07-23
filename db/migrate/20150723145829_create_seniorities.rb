class CreateSeniorities < ActiveRecord::Migration
  def change
    create_table :seniorities do |t|
      t.string :name
      t.string :seniority_type

      t.timestamps null: false
    end
  end
end
