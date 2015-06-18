class CreateTaskInvitations < ActiveRecord::Migration
  def change
    create_table :task_invitations do |t|
      t.references :user, index: true, foreign_key: true
      t.references :task, index: true, foreign_key: true
      t.boolean :accepted, default: false

      t.timestamps null: false
    end
  end
end
