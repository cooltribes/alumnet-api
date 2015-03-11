class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.string :description
      t.string :cover
      t.string :event_type, default: 0
      t.boolean :official, default: false
      t.string :address
      t.date :start_date
      t.string :start_hour
      t.date :end_date
      t.string :end_hour
      t.integer :capacity
      t.integer :invitation_process
      t.references :user
      t.references :city
      t.references :country
      t.references :eventable, polymorphic: true
      t.timestamps
    end
  end
end
