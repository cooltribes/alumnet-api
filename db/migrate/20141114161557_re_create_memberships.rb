class ReCreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.string :mode, index: true
      t.boolean :approved, default: false
      t.boolean :invite_users, default: false
      t.boolean :moderate_members, default: false
      t.boolean :edit_information, default: false
      t.boolean :create_subgroups, default: false
      t.boolean :change_member_type, default: false
      t.boolean :approve_register, default: false
      t.boolean :make_group_official, default: false
      t.boolean :admin, default: false
      t.references :group, index: true
      t.references :user, index: true
      t.datetime :approved_at
      t.timestamps
    end
  end
end
