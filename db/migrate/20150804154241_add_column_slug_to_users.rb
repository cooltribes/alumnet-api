class AddColumnSlugToUsers < ActiveRecord::Migration
  def change
    add_column :users, :slug, :string, index: true
  end
end
