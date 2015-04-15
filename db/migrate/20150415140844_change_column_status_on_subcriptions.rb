class ChangeColumnStatusOnSubcriptions < ActiveRecord::Migration
  def change
    change_column :subscriptions, :status, :integer, default: 1
  end
end
