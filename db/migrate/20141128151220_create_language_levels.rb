class CreateLanguageLevels < ActiveRecord::Migration
  def change
    create_table :language_levels do |t|
      t.references :profile, index: true
      t.references :language, index: true
      t.integer :level

      t.timestamps
    end
  end
end
