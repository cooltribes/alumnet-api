class Membership < ActiveRecord::Base
  ### Constants
  MODES = ["creation", "request", "invitation"]

  ### Relations
  belongs_to :group
  belongs_to :user

  ### Scope
  scope :invitations, -> { where( mode: "invitation", approved: 0 ) }
  scope :requests, -> { where( mode: "request", approved: 0 ) }

  ### Instances Methods

  def approved!
    update_column(:approved, 1)
    touch(:approved_at)
  end

  ### Class Methods
  def self.create_membership_for_creator(group, user)
    attrs = { mode: "creation", approved: 1, moderate_members: 1, edit_infomation: 1,
      create_subgroups:  1, change_member_type: 1, approve_register: 1, make_group_official: 1,
      make_event_official: 1, group: group, user: user }
    create!(attrs)
  end

  def self.create_membership_for_invitation(group, user)
    create!(mode: "invitation", user: user, group: group)
  end

  def self.create_membership_for_request(group, user)
    create!(mode: "request", user: user, group: group)
  end

end
