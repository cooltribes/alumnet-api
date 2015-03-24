class RemoveColumnInvitationProcessFromEvents < ActiveRecord::Migration
  def change
    remove_column :events, :invitation_process
  end
end
