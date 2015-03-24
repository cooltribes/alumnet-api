class ChangeColumnStatusOnAttendances < ActiveRecord::Migration
  def change
    change_column :attendances, :status, :integer, default: 0
  end
end
