class RenameColumnGenreOnProfile < ActiveRecord::Migration
  def change
    rename_column :profiles, :genre, :genrer
  end
end
