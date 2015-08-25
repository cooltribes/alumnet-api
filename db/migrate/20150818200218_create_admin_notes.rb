class CreateAdminNotes < ActiveRecord::Migration
  def change
    create_table :admin_notes do |t|
      t.references :user, index: true
      t.text :body

      t.datetime :deleted_at
      t.timestamps null: false
    end
  end
end
