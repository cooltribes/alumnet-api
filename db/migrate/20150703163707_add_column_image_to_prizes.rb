class AddColumnImageToPrizes < ActiveRecord::Migration
  def change
    add_column :prizes, :image, :string
  end
end
