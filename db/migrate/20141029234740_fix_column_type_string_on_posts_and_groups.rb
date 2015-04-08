class FixColumnTypeStringOnPostsAndGroups < ActiveRecord::Migration
  def change
    change_column :posts, :body, :text
    change_column :groups, :description, :text
  end
end
