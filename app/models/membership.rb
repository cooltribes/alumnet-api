class Membership < ActiveRecord::Base
  acts_as_paranoid

  ### Relations
  belongs_to :group
  belongs_to :user

  ### Validations
  validates_uniqueness_of :group_id, scope: [:user_id]

  ### CallBacks
  before_update :set_admin

  ### Instances Methods

  def permissions_attributes
    [:edit_group, :create_subgroup, :delete_member,
     :change_join_process, :moderate_posts, :make_admin ]
  end

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
      edit_group:           2,
      create_subgroup:      2,
      delete_member:        2,
      change_join_process:  2,
      moderate_posts:       2,
      make_admin:           2,
      admin:                true,
    }
    create!(attrs).approved!
  end

  ## this return the memberships in group where the user is creator. This is a hack for the ui
  def self.by_creator_of_group(user)
    accepted.joins(:group).where({ groups: { creator_id: user.id } })
  end

  def self.where_user_is_admin(user)
    accepted.where(user: user, admin: true)
  end

  private
    def set_admin
      if permissions_attributes.all? { |pa| send(pa) == 0 }
        update_column(:admin, false) if admin
      else
        update_column(:admin, true) if not admin
      end
    end
end