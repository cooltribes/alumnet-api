class CreateTablePrivacyActions < ActiveRecord::Migration
  def change
    create_table :privacy_actions do |t|
      t.string :name
      t.string :description
    end
    add_index :privacy_actions, :name
  end
end
