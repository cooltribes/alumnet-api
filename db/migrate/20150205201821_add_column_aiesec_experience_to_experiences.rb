class AddColumnAiesecExperienceToExperiences < ActiveRecord::Migration
  def change
    add_column :experiences, :aiesec_experience, :string
  end
end
