class User < ActiveRecord::Base
  has_secure_password
  acts_as_messageable

  ### Relations
  has_many :memberships
  has_many :friendships
  has_many :inverse_friendships, class_name: "Friendship", foreign_key: "friend_id"
  has_many :groups, through: :memberships
  has_many :friends, through: :friendships
  has_many :inverse_friends, through: :inverse_friendships, source: :user
  has_many :posts
  has_one :profile
  has_many :likes

  ### Validations
  validates_presence_of :email
  ## TODO add format validation for email.

  ### Callbacks
  before_save :ensure_api_token
  before_create :create_profile

  ### Instance Methods
  def name
    "#{profile.first_name} #{profile.last_name}"
  end

  def avatar
    profile.avatar if profile.present?
  end

  def mailboxer_email(object)
    email
  end

  def ensure_api_token
    if api_token.blank?
      self.api_token = generate_api_token
    end
  end

  ### about friends
  def add_to_friends(user)
    friendships.build(friend_id: user.id)
  end

  def friendship_with(user)
    friendships.find_by(friend_id: user.id) || inverse_friendships.find_by(user_id: user.id)
  end

  def friendship_status_with(user)
    if pending_friendship_with(user).present?
      "sent"
    elsif pending_inverse_friendship_with(user).present?
      "received"
    elsif is_friend_of?(user)
      "accepted"
    else
      "none"
    end
  end

  def is_friend_of?(user)
    accepted_friendship_with(user).present? || accepted_inverse_friendship_with(user).present?
  end

  def find_pending_friendships(filter)
    if filter == "sent"
      pending_friendships
    elsif filter == "received"
      pending_inverse_friendships
    else
      pending_friendships | pending_inverse_friendships
    end
  end

  def find_friends(q)
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
    friends.where("friendships.accepted = ?", true)
  end

  def accepted_inverse_friends
    inverse_friends.where("friendships.accepted = ?", true)
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

  ### about groups
  def can_invite_on_group?(group)
    membership = memberships.find_by(group_id: group.id)
    if membership
      membership.approve_register == 1
    else
      false
    end
  end

  def has_like_in?(likeable)
    likes.exists?(likeable: likeable)
  end


  private

  ### this a temporary solution to authenticate the api
  def generate_api_token
    begin
      return token = SecureRandom.urlsafe_base64(30).tr('lIO0', 'sxyz')
    end while User.exists?(api_token: token)

  end

  def create_profile
    build_profile unless profile.present?
  end
end