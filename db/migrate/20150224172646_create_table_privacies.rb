class CreateTablePrivacies < ActiveRecord::Migration
  def change
    create_table :privacies do |t|
      t.references :user
      t.references :privacy_action
      t.integer :value
    end
  end
end
