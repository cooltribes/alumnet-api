class CreateJoinTableBusinessInfosKeywords < ActiveRecord::Migration
  def change
    create_join_table :business_infos, :keywords do |t|
      t.index [:business_info_id, :keyword_id], name: :index_business_infos_keywords   
    end
  end
end
