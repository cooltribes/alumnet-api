class DropTableMembership < ActiveRecord::Migration
  def change
    drop_table :memberships
  end
end
