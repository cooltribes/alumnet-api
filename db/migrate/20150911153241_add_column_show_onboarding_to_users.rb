class AddColumnShowOnboardingToUsers < ActiveRecord::Migration
  def change
    add_column :users, :show_onboarding, :boolean, default: true
  end
end
