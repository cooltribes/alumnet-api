class CreateProfileVisits < ActiveRecord::Migration
  def change
    create_table :profile_visits do |t|
      t.references :user, index: true
      t.references :visitor, index: true
      t.string :reference

      t.timestamps null: false
    end
  end
end
