class CreateBusinessInfos < ActiveRecord::Migration
  def change
    create_table :business_infos do |t|
      t.integer :type
      t.string :title
      t.string :content
      t.references :company_relation, index: true    

      t.timestamps null: false

    end
  end
end
