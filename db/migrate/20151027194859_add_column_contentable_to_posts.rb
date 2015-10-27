class AddColumnContentableToPosts < ActiveRecord::Migration
  def change
    add_reference :posts, :content, polymorphic: true, index: true
  end
end
