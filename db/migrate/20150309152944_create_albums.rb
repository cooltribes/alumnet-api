class CreateAlbums < ActiveRecord::Migration
  def change
    create_table :albums do |t|
      t.string :name
      t.string :description
      t.references :albumable, polymorphic: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
