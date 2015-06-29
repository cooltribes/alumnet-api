class CreateTaskAttributes < ActiveRecord::Migration
  def change
    create_table :task_attributes do |t|
      t.string :value
      t.string :custom_field
      t.string :attribute_type
      t.integer :profinda_id
      t.references :task, index: true, foreign_key: true
      t.references :attributable, polymorphic: true, index: true
      t.timestamps null: false
    end
  end
end
