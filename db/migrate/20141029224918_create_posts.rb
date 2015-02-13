class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :body
      t.references :user, index: true
      t.references :postable, polymorphic: true
      t.timestamps
    end
  end
end
