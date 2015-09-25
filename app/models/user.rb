class User < ActiveRecord::Base
  has_secure_password
  acts_as_paranoid
  acts_as_messageable
  acts_as_taggable
  include Alumnet::Tag
  include UserHelpers
  include ProfindaRegistration

  ROLES = { system_admin: "SystemAdmin", alumnet_admin: "AlumNetAdmin", external: "External",
    regional_admin: "RegionalAdmin", nacional_admin: "NacionalAdmin", regular: "Regular" }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  VALID_PASSWORD_REGEX = /\A(?=.*[a-zA-Z])(?=.*[0-9]).{8,}\z/

  #0-> no member, 1-> Subscription for a year, 2-> Subscription for a year (30 days left or less), 3-> Lifetime
  MEMBER = { 0=> 'No Member', 1=> 'Member', 2=> 'Member', 3=>'Lifetime Member'}

  RECEPTIVE_POINTS = { 'Regular' => 1, 'NacionalAdmin' => 2, 'RegionalAdmin' => 3, 'AlumNetAdmin' => 4 }

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
  has_many :subscriptions, dependent: :destroy
  has_many :attendances, dependent: :destroy
  has_many :events, as: :eventable, dependent: :destroy
  has_many :invited_events, through: :attendances, source: :event
  has_many :approval_requests, dependent: :destroy
  has_many :pending_approval_requests, class_name: "ApprovalRequest", foreign_key: "approver_id"
  has_many :oauth_providers, dependent: :destroy
  has_many :contacts, dependent: :destroy
  has_many :invitations, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :user_actions, dependent: :destroy
  has_many :user_prizes, dependent: :destroy
  has_many :prizes, through: :user_prizes
  has_many :user_products, dependent: :destroy
  has_many :products, through: :user_products
  has_many :task_invitations, dependent: :destroy
  has_many :matches, dependent: :destroy
  has_many :payments, dependent: :destroy
  has_many :company_admins, dependent: :destroy
  has_many :profile_visits, dependent: :destroy
  has_many :posts_by_like, through: :likes, source: :likeable, source_type: "Post"
  has_one :profile, dependent: :destroy
  has_one :admin_note, dependent: :destroy
  belongs_to :admin_location, polymorphic: true

  ### Scopes
  scope :without_externals, -> { where.not(role: ROLES[:external]) }
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
  before_create :set_default_role, :set_profinda_password
  after_create :create_new_profile
  after_create :create_privacies

  ### Class Methods
  def self.create_from_admin(params)
    user = new
    password = user.generate_random_password
    attributes = { email: params[:email], password: password, password_confirmation: password }
    user.attributes = attributes
    user.created_by_admin = true
    user.role = ROLES[:alumnet_admin] if params[:role] == "admin"
    user.role = ROLES[:regular] if params[:role] == "regular"
    user.role = ROLES[:external] if params[:role] == "external"
    user.save
    user
  end

  ### Instance Methods
  def receptive_points
    value = member > 0 ? 1 : 0
    RECEPTIVE_POINTS[role] + value
  end

  def register_sign_in
    increment!(:sign_in_count)
    touch(:last_sign_in_at)
  end

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

  def aiesec_location
    experience = profile.experiences.aisec.first
    experience ? experience.country.try(:name) : nil
  end

  ##Sugestions Methods
  def suggested_groups(limit = 6)
    aiesec_countries_ids = profile.experiences.aiesec.pluck(:country_id).uniq || []
    profile_countries_ids = [profile.residence_country_id, profile.birth_country_id]
    countries_ids = [aiesec_countries_ids, profile_countries_ids].flatten.uniq
    groups = Group.where(country_id: countries_ids).official
    if groups.size < limit
      groups.to_a | Group.not_secret.order("RANDOM()").limit(limit - groups.size).to_a
    else
      groups.limit(limit).to_a
    end
  end

  def suggested_users(limit = 6)
    committees_ids = profile.committees.pluck(:id)
    aiesec_countries_ids = profile.experiences.aiesec.pluck(:country_id).uniq || []
    users = User.joins(profile: :experiences).where( experiences: { exp_type: 0 })
      .where("experiences.committee_id in (?) or experiences.country_id in (?)", committees_ids, aiesec_countries_ids)
      .where.not(id: id).uniq
    if users.size < limit
      users.to_a | User.order("RANDOM()").limit(limit - users.size).to_a ## complete the limit with ramdon users
    else
      users.limit(limit).to_a
    end
  end

  ### Admin Note
  def set_admin_note(body)
    if admin_note.present?
      admin_note.update(body: body)
    else
      create_admin_note!(body: body)
    end
  end

  ### Groups
  ###this is temp. Refactor this
  def join_to_initial_groups
    initial_groups = Settings.initial_groups
    groups = Group.find(initial_groups)
    groups.each do |group|
      group.build_membership_for(self, true).save unless group.user_has_membership?(self)
    end
  end

  def manage_groups
    groups.where(memberships: { admin: true } )
  end

  def join_groups
    groups.where(memberships: { admin: false } )
  end

  ### Events

  def limit_attend_events(limit = nil)
    invited_events.where(attendances: { status: 1 }).order(:start_date).limit(limit)
  end

  ### Roles
  def activate!
    #To secure that user has completed basic information in first step
    if profile.first_step_completed?
      activate_in_profinda
      activate_in_alumnet
    end
  end

  def activate_in_alumnet
    active!
    join_to_initial_groups unless is_external?
    UserMailer.welcome(self).deliver_later
    touch(:active_at)
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

  def set_role(role)
    send("set_#{role}!")
  end

  def set_regular!
    update_column(:role, ROLES[:regular])
  end

  def set_external!
    update_column(:role, ROLES[:external])
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

  def membership_type
    MEMBER[member]
  end

  def is_regular?
    role == "Regular"
  end

  def is_external?
    role == "External"
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
    Post.joins(:postable_group).where("groups.id in(?)", groups_ids).where(postable_type: "Group")
      .search(q).result
  end

  def my_likes_posts(q)
    posts_by_like.search(q).result
  end

  def friends_posts(q)
    posts = []
    my_friends.each do |friend|
      posts << friend.my_posts(q)
    end
    posts.flatten
  end

  def likes_posts(q)
    posts = []
    my_friends.each do |friend|
      posts << friend.my_likes_posts(q)
    end
    posts.flatten
  end

  def my_posts(q)
    posts.search(q).result | publications.search(q).result
  end

  def all_posts(q)
    posts = groups_posts(q) | my_posts(q) | friends_posts(q) | likes_posts(q)
    posts.sort_by{|e| e[:last_comment_at]}
    posts
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
    member == 2 ? subscriptions.find_by(status:1).days_left : false
  end

  ### premium subscriptions
  #User.member
  #0-> no member, 1-> Subscription for a year, 2-> Subscription for a year (30 days left or less), 3-> Lifetime
  def build_subscription(params, current_user)
    user_subscription = user_subscriptions.build(params)
    user_subscription.ownership_type = 1
    if user_subscription.lifetime?
      user_subscription.subscription = Subscription.lifetime.first
    else
      user_subscription.subscription = Subscription.premium.first
    end
    user_subscription.creator = current_user
    user_subscription
  end

  ### Function to validate users subcription every day

  def validate_subscription
    user_products.where('status = 1').each do |user_product|
      if user_product.product.feature == 'subscription'
        if user_product.end_date && user_product.end_date.past?
          user_product.update_column(:status, 0)
          update_column(:member, 0)
          "expired - user_id: #{id} - #{user_product.end_date}"
        end
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

  ## TASKS
  def has_task_invitation(task)
    task_invitations.exists?(task_id: task.id)
  end
  ##TODO Refactor this :yondri
  def subscribe_to_mailchimp_list(mailchimp, list_id)
    mailchimp_vars = mailchimp.lists.merge_vars({'id' => list_id})
    array = []
    mailchimp_vars['data'][0]['merge_vars'].each do |v|
      array << v['tag']
    end

    all_vars = ["EMAIL", "FNAME", "LNAME", "BIRTHDAY", "GENDER", "B_COUNTRY", "B_CITY", "R_COUNTRY", "R_CITY", "L_EXP", "PREMIUM"]
    all_vars.each do |v|
      if !array.include?(v)
        mailchimp.lists.merge_var_add(list_id, v, v.humanize, [])
      end
    end

    user_vars = {
      'FNAME' => profile.first_name,
      'LNAME' => profile.last_name,
      'BIRTHDAY' => profile.born,
      'GENDER' => profile.gender,
      'B_COUNTRY' => profile.birth_country.name,
      'B_CITY' => profile.birth_city.name,
      'R_COUNTRY' => profile.residence_country.name,
      'R_CITY' => profile.residence_city.name,
      'L_EXP' => profile.last_experience.name,
      'PREMIUM' => membership_type
    }
    mailchimp.lists.subscribe(list_id, {'email' => email}, user_vars, 'html', false, true, true, false)
  end

  ##TODO Refactor this :yondri
  def update_groups_mailchimp()
    all_vars = ["EMAIL", "FNAME", "LNAME", "BIRTHDAY", "GENDER", "B_COUNTRY", "B_CITY", "R_COUNTRY", "R_CITY", "L_EXP", "PREMIUM"]
    groups.official.each do |g|
      if g.mailchimp?
        group_mailchimp = Mailchimp::API.new(g.api_key)
        mailchimp_vars = group_mailchimp.lists.merge_vars({'id' => g.list_id})
        array = []
        mailchimp_vars['data'][0]['merge_vars'].each do |v|
          array << v['tag']
        end

        all_vars.each do |v|
          if !array.include?(v)
            group_mailchimp.lists.merge_var_add(g.list_id, v, v.humanize, [])
          end
        end

        user_vars = {
          'FNAME' => profile.first_name,
          'LNAME' => profile.last_name,
          'BIRTHDAY' => profile.born,
          'GENDER' => profile.gender,
          'B_COUNTRY' => profile.birth_country.name,
          'B_CITY' => profile.birth_city.name,
          'R_COUNTRY' => profile.residence_country.name,
          'R_CITY' => profile.residence_city.name,
          'L_EXP' => profile.last_experience.name,
          'PREMIUM' => membership_type
        }
        group_mailchimp.lists.subscribe(g.list_id, {'email' => email}, user_vars, 'html', false, true, true, false)
      end
    end
  end

  def generate_random_password
    SecureRandom.urlsafe_base64(8).tr('lIO0', 'sxyz')
  end

  def remaining_job_posts
    remaining_job_posts = 0
    feature = Feature.find_by(key_name: 'job_post')
    if feature
      user_products.where(feature_id: feature.id).each do |p|
        if p.transaction_type == 1
          remaining_job_posts += p.quantity
        elsif p.transaction_type == 2
          remaining_job_posts -= p.quantity
        end
      end
    end
    remaining_job_posts
  end

  private

  ### this a temporary solution to authenticate the api
  def generate_token_for(column)
    begin
      return token = SecureRandom.urlsafe_base64(64).tr('lIO0', 'sxyz')
    end while User.exists?(column => token)
  end

  def set_default_role
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