class User < ActiveRecord::Base
  has_secure_password
  mount_uploader :avatar, AvatarUploader
  acts_as_messageable

  ### Relations
  has_many :memberships
  has_many :groups, through: :memberships
  has_many :posts
  has_one :profile

  ### Validations
  validates_presence_of :email
  ## TODO add format validation for email.

  ### Callbacks
  before_save :ensure_api_token
  before_create :create_profile

  ### Instance Methods
  def mailboxer_email(object)
    email
  end

  def ensure_api_token
    if api_token.blank?
      self.api_token = generate_api_token
    end
  end
  def create_profile
    # self.profile.build_other
    self.build_profile
  end

  def can_invite_on_group?(group)
    membership = memberships.find_by(group_id: group.id)
    if membership
      membership.approve_register == 1
    else
      false
    end
  end


  private

  ### this a temporary solution to authenticate the api
  def generate_api_token
    begin
      return token = SecureRandom.urlsafe_base64(30).tr('lIO0', 'sxyz')
    end while User.exists?(api_token: token)

  end
end