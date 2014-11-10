class CreateContactInfos < ActiveRecord::Migration
  def change
    create_table :contact_infos do |t|
      t.integer :type
      t.string :info
      t.integer :privacy

      t.timestamps
    end
  end
end
