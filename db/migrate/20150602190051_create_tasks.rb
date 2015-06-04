class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name
      t.string :description
      t.text :offer
      t.string :duration
      t.date :post_until
      t.string :must_have_list
      t.string :nice_have_list
      t.string :help_type, index: true
      t.integer :profinda_id, null: true
      t.references :company, index: true
      t.references :city, index: true
      t.references :country, index: true
      t.references :user

      t.datetime :deleted_at
      t.timestamps null: false
    end
  end
end
