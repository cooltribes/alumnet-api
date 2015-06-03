class AddKeyNameToActions < ActiveRecord::Migration
  def change
  	add_column :actions, :key_name, :string
  end
end
