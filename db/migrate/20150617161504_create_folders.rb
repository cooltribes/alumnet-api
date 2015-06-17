class CreateFolders < ActiveRecord::Migration
  def change
    create_table :folders do |t|
      t.string :name
      t.references :creator
      t.references :folderable, polymorphic: true
      t.timestamps null: false
    end
  end
end
