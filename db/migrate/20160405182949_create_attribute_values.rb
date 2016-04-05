class CreateAttributeValues < ActiveRecord::Migration
  def change
    create_table :attribute_values do |t|
      t.string :value
      t.integer :status
      t.references :attribute, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
