class AddDefaultValueToCategoryFatherId < ActiveRecord::Migration
  def change
  	change_column_default :categories, :father_id, 0
  end
end
