class CreateEmploymentRelations < ActiveRecord::Migration
  def change
    create_table :employment_relations do |t|
      t.references :user
      t.references :company
      t.boolean :current, default: false
      t.boolean :admin, default: false

      t.timestamps null: false
    end
  end
end
