class ChangeTitleColumnNameForCampaigns < ActiveRecord::Migration
  def change
  	change_table :campaigns do |t|
		  t.rename :title, :subject
		end
  end
end
