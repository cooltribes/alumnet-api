class AddIdToBanner < ActiveRecord::Migration
  def change
    add_column :banners, :banner_id, :integer
  end
end
