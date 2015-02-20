class ChangeColumnDescriptionInExperiences < ActiveRecord::Migration
  def change
    change_column :experiences, :description, :text
  end
end
