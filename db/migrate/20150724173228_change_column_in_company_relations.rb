class ChangeColumnInCompanyRelations < ActiveRecord::Migration
  def change
    change_column :company_relations, :offer, :text
    change_column :company_relations, :search, :text
    change_column :company_relations, :business_me, :text
  end
end
