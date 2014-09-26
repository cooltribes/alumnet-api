class User < ActiveRecord::Base
  has_secure_password

  ### Validations
  validates_presence_of :password, on: :create
  ## TODO add format validation for email.

  ### Callbacks
  before_save :ensure_api_token


  def ensure_api_token
    if api_token.blank?
      self.api_token = generate_api_token
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