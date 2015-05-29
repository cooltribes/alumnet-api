class AddOrderToBanner < ActiveRecord::Migration
  def change
  	add_column :banners, :order, :integer
  	remove_column :banners, :timelapse, :string
  end
end
