class ChangeColumnNameInGroups < ActiveRecord::Migration
  def change
  	change_column :groups, :name, :text
  end
end
