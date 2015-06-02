class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.references :user, index: true, foreign_key: true
      t.references :guest, index: true
      t.string :guest_email
      t.boolean :accepted, default: false
      t.string :token, index: true

      t.datetime :deleted_at
      t.timestamps null: false
    end
  end
end
