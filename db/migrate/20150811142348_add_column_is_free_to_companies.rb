class AddColumnIsFreeToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :is_free, :boolean, default: true
  end
end
