class AddColumnLastCommentAtToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :last_comment_at, :datetime
  end
end
