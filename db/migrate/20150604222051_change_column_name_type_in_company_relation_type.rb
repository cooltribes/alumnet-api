class ChangeColumnNameTypeInCompanyRelationType < ActiveRecord::Migration
  def change
    rename_column :company_relation_keywords, :type, :keyword_type
  end
end
