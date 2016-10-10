class Group < ActiveRecord::Base
  acts_as_tree order: "name", dependent: :nullify
  acts_as_paranoid
  mount_uploader :cover, CoverUploader
  enum group_type: [:open, :closed, :secret]

  include Alumnet::Localizable
  include Alumnet::Croppable
  include Alumnet::Searchable

  ## Virtual Attributes
  attr_accessor :cover_uploader

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
  has_many :folders, as: :folderable, dependent: :destroy
  ##this is for pictures in description.
  has_many :pictures, as: :pictureable, dependent: :destroy
  belongs_to :creator, class_name: 'User'

  has_many :campaigns, dependent: :destroy

  validates_presence_of :api_key, :list_id, if: 'mailchimp?'

  ### Scopes
  scope :open, -> { where(group_type: 0) }
  scope :closed, -> { where(group_type: 1) }
  scope :secret, -> { where(group_type: 2) }
  scope :not_secret, -> { where.not(group_type: 2) }

  scope :official, -> { where(official: true) }
  scope :non_official, -> { where(official: false) }


  ### Validations
  validates_presence_of :name, :short_description, :group_type, :join_process
  validate :validate_join_process, on: :create
  validate :validate_officiality

  ### Callbacks
  before_update :check_join_process
  after_save :save_cover_in_album

  ### class Methods
  def self.without_secret
    where.not(group_type: 2)
  end

  ### instance Methods
  def as_indexed_json(options = {})
    as_json(methods: [:city_info, :country_info])
  end

  def mode
    official? ? "Official" : "Unofficial"
  end

  ### all membership
  def members(excluded_users: nil)
    users.where("memberships.approved = ?", true).where.not(id: excluded_users)
  end

  def admins
    members.where("memberships.admin = ?", true)
  end

  def last_3_members
    members.last(3)
  end

  def last_6_members
    members.last(6)
  end

  def user_is_admin?(user)
    admins.where("users.id = ?", user.id).any?
  end

  def user_is_member?(user)
    members.where("users.id = ?", user.id).any?
  end

  def user_can_upload_files?(user)
    upload_files == 0 ? user_is_admin?(user) : user_is_member?(user)
  end

  def which_friends_in(user)
    members & user.my_friends
  end

  def build_membership_for(user, admin_flag = false)
    if join_process == 0
      memberships.build(user: user, approved: true)
    elsif join_process == 1
      memberships.build(user: user, approved: admin_flag)
    elsif join_process == 2
      memberships.build(user: user, approved: admin_flag)
    end
  end

  ## TODO: refactor this
  def notify(user, sender, admin_flag)
    if join_process == 0
      Notification.notify_join_to_users(user, sender, self)
      # send to admins without current user
      send_to = []
      admins.each do |admin|
        if admin != sender
          send_to << admin
        end
      end
      Notification.notify_join_to_admins(admins.to_a, user, self)
    elsif join_process == 1
      Notification.notify_request_to_users(user, self, sender)
      Notification.notify_request_to_admins(admins.to_a, user, self)
    elsif join_process == 2
      if admin_flag
        Notification.notify_join_to_users(user, sender, self)
      else
        Notification.notify_request_to_users(user, self, sender)
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

  def get_parents(parents = [])
    if self.has_parent?
      parents.push self.parent
      self.parent.get_parents(parents)
    else
      parents
    end
  end

  def last_post
    posts.last
  end

  def first_post
    posts.first
  end

  def group_type_info
    { text: group_type, value: Group.group_types[group_type] }
  end

  def membership_of_user(user)
    memberships.find_by(user_id: user.id)
  end

  def user_has_membership?(user)
    memberships.exists?(user_id: user.id)
  end

  def get_cover_type
    MIME::Types.type_for(cover.card.url).first.try(:content_type) if cover.present?
  end

  def get_cover_base64
    if cover.present?
      if Rails.env.development?
        Base64.encode64(File.open(cover.card.path) { |io| io.read })
      else
        Base64.encode64(open(cover.card.url) { |io| io.read })
      end
    end
  end

  def email_digest
    # test_emails = [
    #   'yroa@upsidecorp.ch', 'yondri@gmail.com', 'jmarquez@cooltribes.com', 'jmarquez@upsidecorp.ch', 'cmarquez@cooltribes.com', 
    #   'carlos.botero@aiesec-alumni.org', 'johannmg@gmail.com', 'francisco@cooltribes.com', 'pirlo@cooltribes.com',
    #   'simon@cooltribes.com', 'dudamel@cooltribes.com', 'elon@cooltribes.com', 'marthy@cooltribes.com', 'ashton@cooltribes.com',
    #   'eric@cooltribes.com', 'margot@cooltribes.com', 'megan@cooltribes.com'
    # ]
    test_emails = ['yroa@upsidecorp.ch', 'yondri@gmail.com']
    users.each do |user|
      if test_emails.include? user.email
        preference = user.group_email_preferences.find_by(group_id: id)
        user_membership = membership_of_user(user)
        if user_membership.status() == 'approved'
          if not(preference.present?) || (preference.present? && preference.value != 0)
            if not preference.present? 
              # send weekly digest by default
              puts '-- ' + user.email + ' -- send weekly default'
              send_digest(user_membership, 'weekly')
            else
              case preference.value
              when 1
                # daily digest
                puts '-- ' + user.email + ' -- send daily'
                send_digest(user_membership, 'daily')
              when 2
                # weekly digest
                send_digest(user_membership, 'weekly')
                puts '-- ' + user.email + ' -- send weekly'
              when 3
                # monthly digest
                send_digest(user_membership, 'monthly')
                puts '-- ' + user.email + ' -- send monthly'
              else
                # weekly digest by default
                send_digest(user_membership, 'weekly')
                puts '-- ' + user.email + ' -- send weekly default'
              end
            end
          else
            puts '-- ' + user.email + ' -- dont'
          end
        end
      end
    end
  end

  def send_digest(user_membership, time_range)
    last_digest = GroupDigest.find_by(membership_id: user_membership.id)
    if not last_digest.present?
      # send email
      digest_posts = get_best_posts('all_time')
      if digest_posts.count > 0
        GroupDigest.create(membership_id: user_membership.id, sent_at: DateTime.now)
        puts '----- Posts: ' + digest_posts.map(&:id).to_json
        #UserMailer.group_digest(user_membership, digest_posts).deliver_now
        mailer = GroupMailer.new
        mailer.send_digest(user_membership, digest_posts)
      else
        puts '---- Not enough posts'
      end
    else
      puts '-- ' + user_membership.user.email + ' - previous digest: ' + last_digest.sent_at.to_s
      if validate_last_digest(last_digest, time_range)
        digest_posts = get_best_posts(time_range)
        if digest_posts.count > 0
          GroupDigest.create(membership_id: user_membership.id, sent_at: DateTime.now)
          #UserMailer.group_digest(user_membership, digest_posts).deliver_now
          mailer = GroupMailer.new
          mailer.send_digest(user_membership, digest_posts)
          puts '-- ' + user_membership.user.email + ' -- send daily'
          puts '----- Posts: ' + digest_posts.map(&:id).to_json
        else
          puts '---- Not enough posts'
        end
      else
        puts '---- Not yet'
      end
    end
  end

  def validate_last_digest(last_digest, time_range)
    send_digest = false
    case time_range
    when 'daily'
      if last_digest.sent_at < DateTime.now - 23.hours
        send_digest = true
      end
    when 'weekly'
      if last_digest.sent_at < DateTime.now - 7.days
        send_digest = true
      end
    when 'monthly'
      if last_digest.sent_at < DateTime.now - 30.days
        send_digest = true
      end
    end
    send_digest
  end

  def get_best_posts(time_range)
    case time_range
    when 'daily'
      posts.where("created_at > ?", DateTime.now - 1.day).limit(3).sort_by{|post| post.likes.count + post.comments.count}.reverse
    when 'weekly'
      posts.where("created_at > ?", DateTime.now - 7.days).limit(3).sort_by{|post| post.likes.count + post.comments.count}.reverse
    when 'monthly'
      posts.where("created_at > ?", DateTime.now - 30.days).limit(3).sort_by{|post| post.likes.count + post.comments.count}.reverse
    else
      posts.limit(3).sort_by{|post| post.likes.count + post.comments.count}.reverse
    end
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