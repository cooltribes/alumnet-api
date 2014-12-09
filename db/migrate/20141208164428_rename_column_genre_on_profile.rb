class RenameColumnGenreOnProfile < ActiveRecord::Migration
  def change
    rename_column :profiles, :genre, :gender
  end
end
