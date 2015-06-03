class CreateActions < ActiveRecord::Migration
  def change
    create_table :actions do |t|
      t.string :name
      t.string :description
      t.integer :status, default: 1
      t.integer :value
      t.timestamps
    end
  end
end
