class CreateFeatures < ActiveRecord::Migration
  def change
    create_table :features do |t|
    	t.string :name
		t.string :description
		t.integer :status, default: 1
		t.string :key_name
		t.timestamps
    end
  end
end
