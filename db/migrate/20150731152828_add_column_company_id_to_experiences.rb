class AddColumnCompanyIdToExperiences < ActiveRecord::Migration
  def change
    add_reference :experiences, :company, index: true
  end
end
