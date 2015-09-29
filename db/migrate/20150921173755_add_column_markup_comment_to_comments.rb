class AddColumnMarkupCommentToComments < ActiveRecord::Migration
  def change
    add_column :comments, :markup_comment, :text
  end
end
