class AddGroupToEmailPreferences < ActiveRecord::Migration
  def change
    add_column :email_preferences, :group, :integer, default: 0
  end
end
