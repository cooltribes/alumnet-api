class AddFatherIdToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :father_id, :integer
    add_index :categories, :father_id
  end
end
