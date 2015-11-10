class AddColumnShortDescriptionToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :short_description, :string
  end
end
