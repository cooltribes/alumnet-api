class AddTitleToBanners < ActiveRecord::Migration
  def change
    add_column :banners, :title, :text
    add_column :banners, :link, :string
    add_column :banners, :description, :text
  end
end
