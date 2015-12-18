class CreateCampaigns < ActiveRecord::Migration
  def change
    create_table :campaigns do |t|
      t.string :title
      t.text :body
      t.references :group, index: true, foreign_key: true
      t.integer :status
      t.string :provider_id
      t.string :list_id
      t.string :segment_id

      t.timestamps null: false
    end
  end
end
