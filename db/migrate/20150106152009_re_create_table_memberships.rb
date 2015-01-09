class ReCreateTableMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.boolean  :approved,            default: false
      t.boolean  :admin,               default: false
      t.integer  :edit_group, default: 0
      t.integer  :create_subgroup, default: 0
      t.integer  :delete_member, default: 0
      t.integer  :change_join_process, default: 0
      t.integer  :moderate_posts, default: 0
      t.integer  :make_admin, default: 0
      t.integer  :group_id
      t.integer  :user_id
      t.datetime :approved_at
      t.timestamps
    end
  end
end
