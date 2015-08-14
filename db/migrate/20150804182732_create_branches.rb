class CreateBranches < ActiveRecord::Migration
  def change
    create_table :branches do |t|
      t.string :address
      t.references :company, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
