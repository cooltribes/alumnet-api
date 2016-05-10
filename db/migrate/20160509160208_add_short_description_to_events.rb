class AddShortDescriptionToEvents < ActiveRecord::Migration
  def change
    add_column :events, :short_description, :string
  end
end
