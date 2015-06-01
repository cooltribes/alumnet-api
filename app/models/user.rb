class User < ActiveRecord::Base
  has_secure_password
  acts_as_paranoid
  acts_as_messageable
  include UserHelpers
  include ProfindaRegistration

  ROLES = { system_admin: "SystemAdmin", alumnet_admin: "AlumNetAdmin",
    regional_admin: "RegionalAdmin", nacional_admin: "NacionalAdmin", regular: "Regular" }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  VALID_PASSWORD_REGEX = /\A(?=.*[a-zA-Z])(?=.*[0-9]).{8,}\z/
  ### Enum
  enum status: [:inactive, :active, :banned]

  ### Relations
  has_many :memberships, dependent: :destroy
  has_many :groups, -> { where("memberships.approved = ?", true) }, through: :memberships
  has_many :friendships, dependent: :destroy
  has_many :inverse_friendships, class_name: "Friendship", foreign_key: "friend_id"
  has_many :friends, through: :friendships
  has_many :inverse_friends, through: :inverse_friendships, source: :user
  has_many :posts, as: :postable, dependent: :destroy
  has_many :publications, class_name: "Post", dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :privacies, dependent: :destroy
  has_many :albums, as: :albumable, dependent: :destroy
  has_many :user_subscriptions, dependent: :destroy
  has_many :subscriptions, through: :user_subscriptions
  has_many :attendances, dependent: :destroy
  has_many :events, as: :eventable, dependent: :destroy
  has_many :invited_events, through: :attendances, source: :event
  has_one :profile, dependent: :destroy
  belongs_to :admin_location, polymorphic: true
  #These are the requests that "self" has made to others
  has_many :approval_requests, dependent: :destroy
  #These are the requests that were made for "self" to approve
  has_many :pending_approval_requests, class_name: "ApprovalRequest", foreign_key: "approver_id"
  has_many :oauth_providers, dependent: :destroy
  has_many :contacts, dependent: :destroy
  has_many :user_actions, dependent: :destroy
  #has_many :actions, through: :user_actions

  ### Scopes
  scope :active, -> { where(status: 1) }
  scope :inactive, -> { where(status: 0) }

  ### Validations
  validates :email, presence: true, uniqueness: true, format: { with: VALID_EMAIL_REGEX, message: "Please enter a valid e-mail address" }
  validates :password, length: { minimum: 8, message: "must contain at least eight (8) characters." },
    format: { with: VALID_PASSWORD_REGEX, message: "must be a combination of numbers and letters" },
    if: 'password.present?'

  ###Nested Atrributes
  accepts_nested_attributes_for :oauth_providers

  ### Callbacks
  before_create :ensure_tokens
  before_create :set_role, :set_profinda_password
  after_create :create_new_profile
  after_create :create_privacies

  ### Instance Methods
  def name
    "#{profile.first_name} #{profile.last_name}"
  end

  def profile
    Profile.unscoped { super }
  end

  def avatar
    profile.avatar if profile.present?
  end

  def cover
    profile.cover if profile.present?
  end

  def mailboxer_email(object)
    email
  end

  def last_experience
    profile.last_experience
  end

  def send_password_reset
    self.password_reset_token = generate_token_for(:password_reset_token)
    self.password_reset_sent_at = Time.current
    save!
    UserMailer.password_reset(self).deliver_later
  end

  def password_reset_token_expired?
    password_reset_sent_at < 2.hours.ago
  end

  def ensure_tokens
    self.auth_token = generate_token_for(:auth_token)
    self.auth_token_created_at = Time.current
  end

  def get_status_info
    { text: status, value: User.statuses[status] }
  end

  def get_member_info
    member
  end

  def first_committee
    profile.experiences.find_by(exp_type: 0).try(:committee).try(:name)
  end

  ### Roles
  def activate!
    if profile.skills? || profile.approval?
      update_or_create_profinda_profile
      active!
      profile.approval!
    else
      false
    end
  end

  def set_admin_role(params)
    if params[:admin_location_id].present?
      if params[:role] == "nacional"
        location = Country.find(params[:admin_location_id])
        update(admin_location: location)
      elsif params[:role] == "regional"
        location = Region.find(params[:admin_location_id])
        update(admin_location: location)
      end
    end
    set_admin!(params[:role])
  end

  def set_admin!(type)
    update_column(:role, ROLES[:"#{type}_admin"])
  end

  def set_regular!
    update_column(:role, ROLES[:regular])
  end

  def is_admin?
    is_system_admin? || is_alumnet_admin? || is_nacional_admin? || is_regional_admin?
  end

  def is_system_admin?
    role == "SystemAdmin"
  end

  def is_alumnet_admin?
    role == "AlumNetAdmin"
  end

  def is_nacional_admin?
    role == "NacionalAdmin"
  end

  def is_regional_admin?
    role == "RegionalAdmin"
  end

  def is_premium?
    member != 0
  end

  def is_regular?
    role == "Regular"
  end

  ### all about Conversations
  def unread_messages_count
    mailbox.inbox.where("mailboxer_receipts.is_read = false").count
  end

  def unread_notifications_count
    mailbox.notifications.unread.count
  end

  ### all about Post
  def groups_posts(q)
    #return all posts of groups where the user is member
    groups_ids = groups.pluck(:id)
    Post.joins(:postable_group).where("groups.id in(?)", groups_ids).search(q).result
  end

  def my_posts(q)
    posts.search(q).result | publications.search(q).result
  end

  def all_posts(q)
    groups_posts(q) | my_posts(q)
  end


  ### all about friends
  def create_friendship_for(user)
    friendships.build(friend_id: user.id)
  end

  def friendship_with(user)
    Friendship.where("(friend_id = :id and user_id = :user_id) or (friend_id = :user_id and user_id = :id)", id: id, user_id: user.id).first
    # friendships.find_by(friend_id: user.id) || inverse_friendships.find_by(user_id: user.id)
  end

  def friendship_status_with(user)
    ##Optimize this
    if is_friend_of?(user) || id == user.id
      "accepted"
    elsif pending_friendship_with(user).present?
      "sent"
    elsif pending_inverse_friendship_with(user).present?
      "received"
    else
      "none"
    end
  end

  def is_friend_of?(user)
    accepted_friendship_with(user).present? || accepted_inverse_friendship_with(user).present?
  end

  def get_pending_friendships(filter)
    if filter == "sent"
      pending_friendships
    elsif filter == "received"
      pending_inverse_friendships
    else
      pending_friendships | pending_inverse_friendships
    end
  end

  def search_accepted_friendships(q)
    accepted_friendships_search = accepted_friendships.search(q)
    accepted_inverse_friendships_search = accepted_inverse_friendships.search(q)
    accepted_friendships_search.result | accepted_inverse_friendships_search.result
  end

  def search_accepted_friends(q)
    accepted_friends_search = accepted_friends.search(q)
    accepted_inverse_friends_search = accepted_inverse_friends.search(q)
    accepted_friends_search.result | accepted_inverse_friends_search.result
  end

  def my_friends
    accepted_friends | accepted_inverse_friends
  end

  def pending_friendship_with(user)
    pending_friendships.find_by(friend_id: user.id)
  end

  def pending_inverse_friendship_with(user)
    pending_inverse_friendships.find_by(user_id: user.id)
  end

  def accepted_friendship_with(user)
    accepted_friendships.find_by(friend_id: user.id)
  end

  def accepted_inverse_friendship_with(user)
    accepted_inverse_friendships.find_by(user_id: user.id)
  end

  def accepted_friends
    friends.where("friendships.accepted = ?", true).where(status: 1)
  end

  def accepted_inverse_friends
    inverse_friends.where("friendships.accepted = ?", true).where(status: 1)
  end

  def accepted_friendships
    friendships.where(accepted: true)
  end

  def accepted_inverse_friendships
    inverse_friendships.where(accepted: true)
  end

  def pending_friendships
    friendships.where(accepted: false)
  end

  def pending_inverse_friendships
    inverse_friendships.where(accepted: false)
  end

  def common_friends_with(user)
    my_friends & user.my_friends
  end

  ### about groups and Membership
  def build_membership_for(group)
    memberships.build(group: group)
  end

  def has_like_in?(likeable)
    likes.exists?(likeable: likeable)
  end

  def days_membership
    member == 2 ? user_subscriptions.find_by(status:1).days_left : false
  end

  ### premium subscriptions
  #User.member
  #0-> no member, 1-> Subscription for a year, 2-> Subscription for a year (30 days left or less), 3-> Lifetime
  def build_subscription(params, current_user)
    user_subscription = user_subscriptions.build(params)
    user_subscription.ownership_type = 1
    if user_subscription.lifetime?
      user_subscription.subscription = Subscription.premium.first
    else
      user_subscription.subscription = Subscription.lifetime.first
    end
    user_subscription.creator = current_user
    user_subscription
  end

  ### Function to validate users subcription every day

  def validate_subscription
    user_subscriptions.where('status = 1').each do |subscription|
      if subscription.end_date && subscription.end_date.past?
        subscription.update_column(:status, 0)
        update_column(:member, 0)
        "expired - user_id: #{id} - #{subscription.end_date}"
      end
    end
  end

  ### Counts

  def friends_count
    my_friends.count
  end

  def pending_received_friendships_count
    pending_inverse_friendships.count
  end

  def pending_sent_friendships_count
    pending_friendships.count
  end

  def pending_approval_requests_count
    get_pending_approval_requests.count
  end

  def approved_requests_count
    get_approved_requests.count
  end

  def mutual_friends_count(user)
    common_friends_with(user).count
  end

  #### Privacy Methods
  # def permit(action, user)
  #   return true if user == self
  #   privacy = privacies.joins(:privacy_action).find_by('privacy_actions.name = ?', action)
  #   if privacy
  #     return true if privacy.value == 2
  #     return is_friend_of?(user) if privacy.value == 1
  #     return (user == self) if privacy.value == 0
  #   else
  #     false
  #   end
  # end

  def permit(action, user)
    return true if user == self
    @privacies ||= get_privacies_hash
    privacy = @privacies[action]
    if privacy
      return true if privacy == 2
      return is_friend_of?(user) if privacy == 1
      return (user == self) if privacy == 0
    else
      false
    end
  end

  def get_privacies_hash
    hash = {}
    privacies.includes(:privacy_action).each do |privacy|
      name = privacy.privacy_action.name
      hash[name] = privacy.value
    end
    hash
  end

  ###Attendances
  def attendance_for(event)
    attendances.find_by(event_id: event.id)
  end

  ##Approval Process
  def create_approval_request_for(user)
    approval_requests.build(approver_id: user.id)
  end

  def approval_with(user)
    ApprovalRequest.where("(approver_id = :id and user_id = :user_id) or (approver_id = :user_id and user_id = :id)", id: id, user_id: user.id).first
  end

  def pending_approval_for(user)
    approval_requests.where(approver_id: user.id, accepted: false).take.present?
  end

  def pending_approval_by(user)
    get_pending_approval_requests.where(user_id: user.id).take.present?
  end

  def get_pending_approval_requests
    pending_approval_requests.where(accepted: false)
  end

  def get_approved_requests
    approval_requests.where(accepted: true)
  end

  def pending_approval_by(user)
    pending_approval_requests.where(user_id: user.id, accepted: false).take.present?
  end

  def has_approved_request_with(user)
    approval_requests.where(approver_id: user.id, accepted: true).take.present? ||
    pending_approval_requests.where(user_id: user.id, accepted: true).take.present?
  end

  def approval_status_with(user)
    ##Optimize this
    if has_approved_request_with(user) || id == user.id
      "accepted"
    elsif pending_approval_for(user).present?
      "sent"
    elsif pending_approval_by(user).present?
      "received"
    else
      "none"
    end
  end

  private

  ### this a temporary solution to authenticate the api
  def generate_token_for(column)
    begin
      return token = SecureRandom.urlsafe_base64(64).tr('lIO0', 'sxyz')
    end while User.exists?(column => token)
  end

  def set_role
    self[:role] = ROLES[:regular] unless role.present?
  end

  def set_profinda_password
    self[:profinda_password] = 'xwggk39V9m6AByUVbS8e'
  end

  def create_new_profile
    create_profile unless profile.present?
  end

  def create_privacies
    PrivacyAction.all.each do |action|
      unless privacies.exists?(privacy_action_id: action.id)
        privacies.create(privacy_action_id: action.id, value: 2)
      end
    end
  end

end