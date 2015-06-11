class CreateCompanyRelationKeywords < ActiveRecord::Migration
  def change
    create_table :company_relation_keywords do |t|
      t.references :company_relation, index: true
      t.references :keyword, index: true
      t.integer :type

      t.timestamps

    end
  end
end
