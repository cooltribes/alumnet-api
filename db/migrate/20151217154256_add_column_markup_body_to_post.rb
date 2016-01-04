class AddColumnMarkupBodyToPost < ActiveRecord::Migration
  def change
    add_column :posts, :markup_body, :text
  end
end
