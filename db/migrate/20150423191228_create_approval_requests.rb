class CreateApprovalRequests < ActiveRecord::Migration
  def change
    create_table :approval_requests do |t|
      t.references :approver, index: true
      t.references :user, index: true
      t.boolean :accepted, default: false
      t.datetime :accepted_at
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
