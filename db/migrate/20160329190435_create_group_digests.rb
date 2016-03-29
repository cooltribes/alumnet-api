class CreateGroupDigests < ActiveRecord::Migration
  def change
    create_table :group_digests do |t|
      t.integer :status, default: 0
      t.datetime :sent_at
      t.references :membership, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end