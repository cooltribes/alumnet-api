class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.string :mode, index: true
      t.integer :approved, default: 0
      t.integer :moderate_members, default: 0
      t.integer :edit_infomation, default: 0
      t.integer :create_subgroups, default: 0
      t.integer :change_member_type, default: 0
      t.integer :approve_register, default: 0
      t.integer :make_group_official, default: 0
      t.integer :make_event_official, default: 0
      t.references :group, index: true
      t.references :user, index: true
      t.datetime :approved_at
      t.timestamps
    end
  end
end
