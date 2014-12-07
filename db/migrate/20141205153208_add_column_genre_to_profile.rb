class AddColumnGenreToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :genre, :string
  end
end
