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

  ### Scopes

  scope :open, -> { where(group_type: 0) }
  scope :closed, -> { where(group_type: 1) }
  scope :secret, -> { where(group_type: 2) }

  scope :official, -> { where(official: true) }
  scope :non_official, -> { where(official: false) }


  ### Validations
  validates_presence_of :name, :description, :group_type, :join_process, :cover
  validate :validate_join_process, on: :create

  ### Callbacks
  before_update :check_join_process

  ### class Methods
  def self.without_secret
    where.not(group_type: 2)
  end

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
    if country
      { text: country.name, value: country_id}
    else
      { text: "", value: ""}
    end
  end

  def get_city_info
    if city
      { text: city.name, value: city_id}
    else
      { text: "", value: ""}
    end
  end

  def creator
    creator_user_id.present? ? User.find_by(id: creator_user_id) : nil
  end

  def membership_of_user(user)
    memberships.find_by(user_id: user.id)
  end

  private
    def validate_join_process
      if (group_type == "secret" && join_process < 2) || (group_type == "closed" && join_process == 0)
        errors.add(:join_process, "invalid option")
      end
    end

    def check_join_process
      ## this change the join process automatically on update
      if (group_type == "secret" && join_process < 2) || (group_type == "closed" && join_process == 0)
        self[:join_process] = 2
      end

    end
end