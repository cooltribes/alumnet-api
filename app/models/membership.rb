class Membership < ActiveRecord::Base

  ### Relations
  belongs_to :group
  belongs_to :user

  ### Validations
  validates_uniqueness_of :group_id, scope: [:user_id]

  ### Instances Methods

  def status
    approved ? "approved" : "pending"
  end

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
      group:                group,
      user:                 user,
      edit_group:           3,
      create_subgroup:      3,
      delete_member:        3,
      change_join_process:  3,
      moderate_posts:       3,
      make_admin:           3,
      admin:                true,
    }
    create!(attrs).approved!
  end

  def self.create_membership_for_invitation(group, user)
    create!(user: user, group: group)
    Notification.notify_invitation_to_users(user, group)
    #Notification.notify_invitation_to_admins()
  end

  def self.create_membership_for_request(group, user)
    membership = create!(user: user, group: group)
    if group.open?
      membership.approved!
      Notification.notify_join_to_users(user, group)
      # send notificacion to user and group.admins
    elsif group.closed?
      #send notificacion to user and group.admins
    end
  end

end