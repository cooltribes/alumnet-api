class CreateCharacteristicValues < ActiveRecord::Migration
  def change
    create_table :characteristic_values do |t|
		t.string :value
		t.integer :status
		t.references :characteristic, index: true, foreign_key: true
		
		t.timestamps null: false
    end
  end
end
