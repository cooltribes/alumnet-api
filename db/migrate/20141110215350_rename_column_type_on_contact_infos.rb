class RenameColumnTypeOnContactInfos < ActiveRecord::Migration
  def change
    rename_column :contact_infos, :type, :contact_type

  end
end
