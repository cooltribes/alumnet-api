class AddDetailsToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :url, :string
    add_column :posts, :url_title, :string
    add_column :posts, :url_description, :string
    add_column :posts, :url_image, :string
  end
end
