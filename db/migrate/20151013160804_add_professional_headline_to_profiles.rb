class AddProfessionalHeadlineToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :professional_headline, :string
  end
end