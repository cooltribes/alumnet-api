class CreateEventPayments < ActiveRecord::Migration
  def change
    create_table :event_payments do |t|
      t.decimal :price
      t.string :reference
      t.references :user, index: true
      t.references :event, index: true
      t.timestamps
    end
  end
end