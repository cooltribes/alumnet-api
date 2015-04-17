class ChangeColumnNameInEvents < ActiveRecord::Migration
  def change
  	change_column :events, :name, :text
  end
end
