class Group < ActiveRecord::Base
  acts_as_tree order: "name", dependent: :nullify
  acts_as_paranoid
  mount_uploader :cover, CoverUploader
  enum group_type: [:open, :closed, :secret]

  ## Virtual Attributes
  attr_accessor :cover_uploader
  attr_accessor :imgInitH, :imgInitW, :imgW, :imgH, :imgX1, :imgY1, :cropW, :cropH

  #join_process
  # "0" -> All Members can invite
  # "1" -> All Members can invite, but the admins approved
  # "2" -> Only the admins can invite

  #upload_files
  # "0" -> Only the admins can upload
  # "1" -> All Members can upload

  ### Relations

  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships
  has_many :posts, as: :postable, dependent: :destroy
  has_many :albums, as: :albumable, dependent: :destroy
  has_many :events, as: :eventable, dependent: :destroy
  belongs_to :creator, class_name: 'User'
  belongs_to :country
  belongs_to :city
  has_many :albums, as: :albumable, dependent: :destroy
  has_many :folders, as: :folderable, dependent: :destroy

  validates_presence_of :api_key, :list_id, if: 'mailchimp?'

  ### Scopes
  scope :open, -> { where(group_type: 0) }
  scope :closed, -> { where(group_type: 1) }
  scope :secret, -> { where(group_type: 2) }

  scope :official, -> { where(official: true) }
  scope :non_official, -> { where(official: false) }


  ### Validations
  validates_presence_of :name, :description, :group_type, :join_process, :cover
  validate :validate_join_process, on: :create
  validate :validate_officiality

  ### Callbacks
  before_update :check_join_process
  after_save :save_cover_in_album

  ### class Methods
  def self.without_secret
    where.not(group_type: 2)
  end

  ### Croping Cover
  def crop
    cover.recreate_versions! if imgX1.present?
    save!
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

  def user_is_member?(user)
    members.where("users.id = ?", user.id).any?
  end

  def user_can_upload_file?(user)
    upload_files == 0 ? user_is_admin?(user) : user_is_member?(user)
  end

  def which_friends_in(user)
    members & user.my_friends
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
  def notify(user, admin, current_user)
    if join_process == 0
      Notification.notify_join_to_users(user, self, current_user)
      Notification.notify_join_to_admins(admins.to_a, user, self)
    elsif join_process == 1
      Notification.notify_request_to_users(user, self, current_user)
      Notification.notify_request_to_admins(admins.to_a, user, self)
    elsif join_process == 2
      if admin
        Notification.notify_join_to_users(user, self, current_user)
      else
        Notification.notify_request_to_users(user, self, current_user)
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

  def has_official_parent?
    has_parent? && parent.official?
  end

  def has_official_children?
    has_children? ? children.where(official:true).any? : false
  end

  def can_be_official?
    return true unless has_parent?
    return true if has_official_parent?
    false
  end

  def can_be_unofficial?
    return true unless has_official_children?
    false
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

  def membership_of_user(user)
    memberships.find_by(user_id: user.id)
  end

  private
    def validate_join_process
      if (group_type == "secret" && join_process < 2) || (group_type == "closed" && join_process == 0)
        errors.add(:join_process, "invalid option")
      end
    end

    def validate_officiality
      if official? and not can_be_official?
        errors.add(:official, "the group can not be official")
      elsif not official? and not can_be_unofficial?
        errors.add(:official, "the group can be official")
      end
    end

    def check_join_process
      ## this change the join process automatically on update
      if (group_type == "secret" && join_process < 2) || (group_type == "closed" && join_process == 0)
        self[:join_process] = 2
      end
    end

    def save_cover_in_album
      if cover_changed?
        album = albums.create_with(name: 'covers').find_or_create_by(album_type: Album::TYPES[:cover])
        picture = Picture.new(uploader: cover_uploader)
        picture.picture = cover
        album.pictures << picture
      end
    end

end