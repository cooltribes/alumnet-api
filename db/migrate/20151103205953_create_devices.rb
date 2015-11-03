class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :platform
      t.string :token
      t.boolean :active, default: true
      t.references :user, index: true

      t.timestamps null: false
    end
  end
end
