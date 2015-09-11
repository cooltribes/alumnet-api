class AddColumnPositionToUserTaggings < ActiveRecord::Migration
  def change
    add_column :user_taggings, :position, :text
  end
end
