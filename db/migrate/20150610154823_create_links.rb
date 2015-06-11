class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.string :title
      t.string :description
      t.string :url    
      t.references :company_relation
      t.timestamps

    end
  end
end
