class CreateJoinTable < ActiveRecord::Migration
  def change
    create_join_table :languages, :profiles do |t|
      # t.index [:language_id, :profile_id]
      t.index [:profile_id, :language_id]
    end
  end
end
