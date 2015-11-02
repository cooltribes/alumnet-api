class AddColumnContentableToPosts < ActiveRecord::Migration
  def change
    add_reference :posts, :content, polymorphic: true, index: true
    add_column :posts, :post_type, :string
  end
end
