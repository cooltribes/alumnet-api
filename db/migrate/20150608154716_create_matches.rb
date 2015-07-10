class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.references :task, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.boolean :applied, default: false

      t.timestamps null: false
    end
  end
end
