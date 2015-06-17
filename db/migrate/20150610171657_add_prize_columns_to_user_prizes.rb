class AddPrizeColumnsToUserPrizes < ActiveRecord::Migration
  def change
    add_column :user_prizes, :prize_type, :integer
    add_column :user_prizes, :remaining_quantity, :integer
  end
end
