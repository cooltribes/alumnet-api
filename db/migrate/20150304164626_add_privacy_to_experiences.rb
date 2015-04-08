class AddPrivacyToExperiences < ActiveRecord::Migration
  def change
    add_column :experiences, :privacy, :integer, default: 2
  end
end
