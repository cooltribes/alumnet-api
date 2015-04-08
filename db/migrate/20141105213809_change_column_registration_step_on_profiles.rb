class ChangeColumnRegistrationStepOnProfiles < ActiveRecord::Migration
  def change
    change_column :profiles, :register_step, :integer, default: 0
  end
end
