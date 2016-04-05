class CreateAttributes < ActiveRecord::Migration
  def change
    create_table :attributes do |t|
      t.string :name
      t.integer :status
      t.integer :mandatory
      t.string :measure_unit

      t.timestamps null: false
    end
  end
end
