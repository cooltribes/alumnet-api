class Group < ActiveRecord::Base
  acts_as_tree order: "name"
  mount_uploader :cover, CoverUploader
  enum group_type: [:open, :closed, :secret]

  #join_process
  # "0" -> All Members can invite
  # "1" -> All Members can invite, but the admins approved
  # "2" -> Only the admins can invite


  ### Relations
  has_many :memberships
  has_many :users, through: :memberships
  has_many :posts, as: :postable
  belongs_to :country
  belongs_to :city

  ### Validations
  validates_presence_of :name, :description, :cover, :group_type, :country_id,
    :city_id, :join_process

  ### Instance Methods

  ### all membership
  def members
    users.where("memberships.approved = ?", true)
  end

  def admins
    members.where("memberships.admin = ?", true)
  end

  def user_is_admin?(user)
    admins.where("users.id = ?", user.id).any?
  end

  def build_membership_for(user, admin = false)
    if join_process == 0
      memberships.build(user: user, approved: true)
    elsif join_process == 1
      memberships.build(user: user, approved: admin)
    elsif join_process == 2
      memberships.build(user: user, approved: admin)
    end
  end

  ## TODO: refactor this
  def notify(user, admin)
    if join_process == 0
      Notification.notify_join_to_users(user, self)
      Notification.notify_join_to_admins(admins.to_a, user, self)
    elsif join_process == 1
      Notification.notify_request_to_users(user, self)
      Notification.notify_request_to_admins(admins.to_a, user, self)
    elsif join_process == 2
      if admin
        Notification.notify_join_to_users(user, self)
      else
        Notification.notify_request_to_users(user, self)
        Notification.notify_request_to_admins(admins.to_a, user, self)
      end
    end
  end

  def has_parent?
    parent.present?
  end

  def has_children?
    children.any?
  end

  def last_post
    posts.last
  end

  def get_group_type_info
    { text: group_type, value: Group.group_types[group_type] }
  end

  def get_country_info
    { text: country.name, value: country_id}
  end

  def get_city_info
    { text: city.name, value: city_id}
  end

  def creator
    creator_user_id.present? ? User.find_by(id: creator_user_id) : nil
  end

  def membership_of_user(user)
    memberships.find_by(user_id: user.id)
  end
end