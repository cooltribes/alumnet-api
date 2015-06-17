class AddColumnTaglineToCompanyRelations < ActiveRecord::Migration
  def change
    add_column :company_relations, :tagline, :string
  end
end
