class RenameColumnEditInfomationOnMembership < ActiveRecord::Migration
  def change
    rename_column :memberships, :edit_infomation, :edit_information
  end
end
