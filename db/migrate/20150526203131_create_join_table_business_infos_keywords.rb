class CreateJoinTableBusinessInfosKeywords < ActiveRecord::Migration
  def change
    create_join_table :business_infos, :skills do |t|
      t.index [:business_info_id, :skill_id]   
    end
  end
end
