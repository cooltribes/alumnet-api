class RemoveCategoryIdFromProducts < ActiveRecord::Migration
  def change
  	change_table :products do |t|
  		t.remove :category_id
  	end
  end
end
