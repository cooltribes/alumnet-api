class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.string :title
      t.string :picture      
      t.date :date_taken
      t.references :album, index: true

      t.timestamps
    end
  end
end
