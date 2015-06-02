class AddColumnTimeLapsePictureToBanner < ActiveRecord::Migration
  def change
    add_column :banners, :picture, :string
    add_column :banners, :timelapse, :string
  end
end
