class Membership < ActiveRecord::Base
  ### Constants
  MODES = ["creation", "request", "invitation"]

  ### Relations
  belongs_to :group
  belongs_to :user

  ### Instances Methods

  def approved!
    update_column(:approved, true)
    touch(:approved_at)
  end

  ### Class Methods
  def self.accepted
    where(approved: true)
  end

  def self.pending
    where(approved: false)
  end

  def self.create_membership_for_creator(group, user)
    attrs = {
      mode:                "creation",
      group:               group,
      user:                user,
      invite_users:        false,
      moderate_members:    false,
      edit_information:    false,
      create_subgroups:    false,
      change_member_type:  false,
      approve_register:    false,
      make_group_official: false,
      admin:               false,
    }
    create!(attrs).approved!
  end

  def self.create_membership_for_invitation(group, user)
    create!(mode: "invitation", user: user, group: group)
    Notification.notify_invitation_to_users(user, group)
    #Notification.notify_invitation_to_admins()
  end

  def self.create_membership_for_request(group, user)
    membership = create!(mode: "request", user: user, group: group)
    if group.open?
      membership.approved!
      Notification.notify_join_to_users(user, group)
      # send notificacion to user and group.admins
    elsif group.closed?
      #send notificacion to user and group.admins
    end
  end

end
