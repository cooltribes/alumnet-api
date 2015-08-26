class CreateUserTaggings < ActiveRecord::Migration
  def change
    create_table :user_taggings do |t|
      t.references :user, index: true
      t.references :tagger, index: true
      t.references :taggable, polymorphic: true
      t.timestamps null: false
    end
  end
end
