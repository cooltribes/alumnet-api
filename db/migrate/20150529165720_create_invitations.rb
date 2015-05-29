class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.references :user, index: true, foreign_key: true
      t.references :guest, index: true
      t.string :guest_email, index: true
      t.boolean :accepted, default: false
      t.string :token

      t.datetime :deleted_at
      t.timestamps null: false
    end
  end
end
