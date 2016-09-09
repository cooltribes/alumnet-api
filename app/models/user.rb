class User < ActiveRecord::Base
  has_secure_password
  acts_as_paranoid
  acts_as_messageable
  acts_as_taggable
  include Alumnet::Amigable
  include Alumnet::Tag

  include UserHelpers
  include ProfindaRegistration

  ROLES = { system_admin: "SystemAdmin", alumnet_admin: "AlumNetAdmin", external: "External",
    regional_admin: "RegionalAdmin", nacional_admin: "NacionalAdmin", regular: "Regular" }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  VALID_PASSWORD_REGEX = /\A(?=.*[a-zA-Z])(?=.*[0-9]).{8,}\z/

  #0-> no member, 1-> Subscription for a year, 2-> Subscription for a year (30 days left or less), 3-> Lifetime
  MEMBER = { 0=> 'No Member', 1=> 'Member', 2=> 'Member', 3=>'Lifetime Member'}

  RECEPTIVE_POINTS = { 'Regular' => 1, 'NacionalAdmin' => 2, 'RegionalAdmin' => 3, 'AlumNetAdmin' => 4, 'SystemAdmin' => 4 }

  ### Enum
  enum status: [:inactive, :active, :banned]

  ### Relations

  has_many :memberships, dependent: :destroy
  has_many :groups, -> { where("memberships.approved = ?", true) }, through: :memberships
  has_many :created_groups, class_name: "Group", foreign_key: "creator_id"
  has_many :posts, as: :postable, dependent: :destroy
  has_many :publications, class_name: "Post", dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
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
  has_many :managed_companies, -> { where(company_admins: {status: 1}) }, through: :company_admins, source: :company
  has_many :profile_visits, dependent: :destroy
  has_many :posts_by_like, through: :likes, source: :likeable, source_type: "Post"
  has_many :devices, dependent: :destroy
  has_many :email_preferences, dependent: :destroy
  has_many :group_email_preferences, dependent: :destroy
  has_one :profile, dependent: :destroy
  has_one :admin_note, dependent: :destroy
  belongs_to :admin_location, polymorphic: true


  ### Scopes
  scope :alumnet_admins, -> { where(role: ROLES[:alumnet_admin]) }
  scope :admins, -> { where.not(role: ROLES[:regular]) }
  scope :without_externals, -> { where.not(role: ROLES[:external]) }
  scope :active, -> { where(status: 1) }
  scope :inactive, -> { where(status: 0) }

  scope :approvals_count, ->(count) { joins(:approval_requests)
    .where(approval_requests: { accepted: true } )
    .group('users.id')
    .having('count(approval_requests.id)=?', count) }

  ### Validations
  validates :email, presence: true, uniqueness: true, format: { with: VALID_EMAIL_REGEX, message: "Please enter a valid e-mail address" }
  validates :password, length: { minimum: 8, message: "must contain at least eight (8) characters." },
    format: { with: VALID_PASSWORD_REGEX, message: "must be a combination of numbers and letters" },
    if: 'password.present?'

  ###Nested Atrributes
  accepts_nested_attributes_for :oauth_providers

  ### Callbacks
  before_validation :downcase_email
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

  def self.search_in_location(location, query)
    locations = location.is_a?(Country) ? [location.id] : location.country_ids
    includes(:profile).ransack(query).result.where(profiles: { residence_country_id: locations})
  end

  ### Instance Methods

  def devices_tokens(platform)
    devices.where(platform: platform).where(active: true).pluck(:token)
  end

  def receptive_points
    value = member > 0 ? 1 : 0
    RECEPTIVE_POINTS[role] + value
  end

  def register_sign_in
    increment!(:sign_in_count)
    touch(:last_sign_in_at)
  end

  def name
    profile.name
  end

  def age
    profile.age
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

  def full_last_experience
    last_experience = ''
    last_experience = self.last_experience.name if self.last_experience.present?
    last_experience += " at " + self.last_experience.organization_name if self.last_experience.present? && self.last_experience.organization_name.present?
    last_experience
  end

  def get_avatar_type
    MIME::Types.type_for(avatar.url).first.try(:content_type)
  end

  def get_avatar_base64
    if Rails.env.development?
      Base64.encode64(File.open(self.avatar.path) { |io| io.read }) if self.avatar.path.present?
    else
      Base64.encode64(open(self.avatar.url) { |io| io.read })
    end
  end

  def location
    profile.residence_country.present? ? profile.residence_country.name : 'N/A'
  end

  def send_password_reset
    self.password_reset_token = generate_token_for(:password_reset_token)
    self.password_reset_sent_at = Time.current
    save!
    UserMailer.password_reset(self).deliver_later
  end

  def new_password_reset_token
    self.password_reset_token = generate_token_for(:password_reset_token)
    self.password_reset_sent_at = Time.current
    save!
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
    experience.try(:country).try(:name)
  end


  ##Mailboxer Methods
  #TODO: quitar parentesis y refatorizar los counts :yondri
  def messages_with_includes
    receipts.messages_receipts.includes(message: [{sender: :profile}, :conversation])
  end

  def last_week_approval_notifications()
    mailbox.notifications.joins(:notification_detail)
    .where(notification_details: {notification_type: ['approval']})
    .where("notification_details.created_at >= ?", 2.days.ago.utc)
  end

  def friendship_notifications()
    mailbox.notifications.joins(:notification_detail)
    .where(notification_details: {notification_type: ['friendship', 'approval']})
  end

  def general_notifications()
    mailbox.notifications.joins(:notification_detail)
    .where.not(notification_details: {notification_type: ['friendship', 'approval']})
  end

  ### all about Conversations
  def unread_messages_count
    mailbox.conversations.where("mailboxer_receipts.is_read = false").count
  end

  def unread_notifications_count
    mailbox.notifications.joins(:notification_detail)
    .where.not(notification_details: {notification_type: ['friendship', 'approval']}).unread.count
  end

  def unread_friendship_notifications_count
    mailbox.notifications.joins(:notification_detail)
    .where(notification_details: {notification_type: ['friendship', 'approval']}).unread.count
  end

  ##Sugestions Methods
  def suggested_groups(limit = 6)
    suggest_limit = (limit.to_i - 1) > 0 ? (limit.to_i - 1) : 0
    suggestions = Suggesters::SuggesterGroups.new(self, limit: 6)
    suggestions.results[0..(suggest_limit)]
  end

  def suggested_users(limit = 6)
    suggest_limit = (limit.to_i - 1) > 0 ? (limit.to_i - 1) : 0
    suggestions = Suggesters::SuggesterUsers.new(self, limit: 6)
    suggestions.results[0..(suggest_limit)]
  end

  def suggested_events(limit = 6)
    suggest_limit = (limit.to_i - 1) > 0 ? (limit.to_i - 1) : 0
    suggestions = Suggesters::SuggesterEvents.new(self, limit: 6)
    suggestions.results[0..(suggest_limit)]
  end

  def suggested_companies(limit = 6)
    suggest_limit = (limit.to_i - 1) > 0 ? (limit.to_i - 1) : 0
    suggestions = Suggesters::SuggesterCompanies.new(self, limit: 6)
    suggestions.results[0..(suggest_limit)]
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
    # This is a temp hack.. fix soon! :armando
  def managed_events(query)
    Event.ransack(query).result.select do |event|
      event.is_admin?(self)
    end
  end

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
    #UserMailer.welcome(self).deliver_later
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

  def he_or_she
    profile.gender == "M" ? "he\'s" : "she\'s"
  end

  ### all about Post
  def groups_posts(q)
    #return all posts of groups where the user is member
    groups_ids = groups.pluck(:id)
    Post.with_includes.joins(:postable_group).where(postable_type: "Group")
      .where("groups.id in(?) and groups.group_type = ?", groups_ids, 0)
      .where('posts.updated_at > ?', 3.months.ago)
      .ransack(q).result
  end

  def my_likes_posts(q)
    posts = posts_by_like.with_includes.where('posts.updated_at > ?', 3.months.ago).ransack(q).result.to_a
    posts.reject! do |post|
      post.in_group_closed_or_secret? || post.in_event_closed_or_secret?
    end
    posts
  end

  def friends_posts(query)
    posts = []
    my_friends.each do |friend|
      posts << friend.publicable_posts(query)
    end
    posts.flatten
  end

  def likes_posts(query)
    posts = []
    my_friends.each do |friend|
      posts << friend.my_likes_posts(query)
    end
    posts.flatten
  end

  def my_posts(query)
    posts.with_includes.where('updated_at > ?', 3.months.ago).ransack(query).result | publications.with_includes.where('updated_at > ?', 3.months.ago).ransack(query).result
  end

  def publicable_posts(query)
    posts = []
    my_posts(query).each do |post|
      posts << post unless post.in_group_closed_or_secret? || post.in_event_closed_or_secret?
    end
    posts
  end

  def all_posts(query)
    posts = likes_posts(query) | friends_posts(query) | groups_posts(query) | my_posts(query)
    posts.sort!{ |a,b| b.last_comment_at <=> a.last_comment_at }
    posts
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
    # TODO: refactorizar esto con : through para acceder directo a .product :yondri
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
  def approval_status
    return "A" if created_by_admin
    approval_requests.accepted.count
  end

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

  def get_pending_approval_requests(q = nil)
    pending_approval_requests.where(accepted: false).ransack(q).result
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

  def has_rejected_request_with(user)
    approval_requests.where(approver_id: user.id, accepted: false).take.present?
  end

  def approval_status_with(user)
    ##Optimize this
    if has_approved_request_with(user) || id == user.id
      "accepted"
    elsif pending_approval_for(user).present?
      "sent"
    elsif pending_approval_by(user).present?
      "received"
    elsif has_rejected_request_with(user).present?
      "rejected"
    else
      "none"
    end
  end

  def switch_approval_to_friendship
    requests = approval_requests
    requests.each do |r|
      if r.accepted == false
        friendship = self.create_friendship_for(r.approver)
        if friendship.save
          Notification.notify_friendship_request_to_user(self, r.approver)
        end
        notifications = NotificationDetail.where(notification_type:'approval', sender_id: self.id)
        notifications.each do |notification|
          if notification.mailboxer_notification.present?
            if notification.mailboxer_notification.notified_object_id == r.approver.id
              notification.mailboxer_notification.destroy
            end
          end
        end
        r.destroy
      end
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
    if mailchimp_vars['error_count'] == 0
      mailchimp_vars['data'][0]['merge_vars'].each do |v|
        array << v['tag']
      end
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
      'B_COUNTRY' => profile.birth_country.present? ? profile.birth_country.name : "",
      'B_CITY' => profile.birth_city.present? ? profile.birth_city.name : "",
      'R_COUNTRY' => profile.residence_country.present? ? profile.residence_country.name : "",
      'R_CITY' => profile.residence_city.present? ? profile.residence_city.name : "",
      'L_EXP' => profile.last_experience.present? ? profile.last_experience.name : "",
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
          'B_COUNTRY' => profile.birth_country.present? ? profile.birth_country.name : "",
          'B_CITY' => profile.birth_city.present? ? profile.birth_city.name : "",
          'R_COUNTRY' => profile.residence_country.present? ? profile.residence_country.name : "",
          'R_CITY' => profile.residence_city.present? ? profile.residence_city.name : "",
          'L_EXP' => profile.last_experience.present? ? profile.last_experience.name : "",
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
    user_products.where(feature: 'job_post').each do |p|
      if p.transaction_type == 1
        remaining_job_posts += p.quantity
      elsif p.transaction_type == 2
        remaining_job_posts -= p.quantity
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

  def downcase_email
    self.email = self.email.downcase if self.email.present?
  end
end