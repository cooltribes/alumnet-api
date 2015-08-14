class CreateCompanyAdmins < ActiveRecord::Migration
  def change
    create_table :company_admins do |t|
      t.references :user, index: true
      t.references :company, index: true
      t.integer :status, default: 0
      t.integer :accepted_by, index: true

      t.timestamps null: false
    end
  end
end
