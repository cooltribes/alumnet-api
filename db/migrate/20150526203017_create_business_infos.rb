class CreateBusinessInfos < ActiveRecord::Migration
  def change
    create_table :business_infos do |t|
      t.integer :type
      t.string :title
      t.string :content
      t.references :profile, index: true    

      t.timestamps
    end
  end
end
