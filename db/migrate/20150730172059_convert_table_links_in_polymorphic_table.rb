class ConvertTableLinksInPolymorphicTable < ActiveRecord::Migration
  def change
    add_column :links, :linkable_type, :string
    add_column :links, :linkable_id, :integer
    remove_column :links, :company_relation_id
    add_index :links, [:linkable_id, :linkable_type]
  end
end
