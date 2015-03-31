class CreateAttendances < ActiveRecord::Migration
  def change
    create_table :attendances do |t|
      t.integer :status
      t.references :user, index: true
      t.references :event, index: true

      t.timestamps
    end
  end
end
