class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.string :description
      t.string :avatar
      t.integer :group_type, default: 0

      t.timestamps
    end
  end
end
