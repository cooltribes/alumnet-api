require 'mailchimp'

class ApplicationController < ActionController::API
  include ActionController::ImplicitRender
  include ActionController::HttpAuthentication::Token::ControllerMethods

  #before_action :setup_mcapi
  before_action :authenticate
  before_action :set_request_format

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def current_user
    @current_user
  end
  helper_method :current_user

  protected
  def authenticate
    if user = authenticate_with_http_token { |t, o| User.find_by(auth_token: t) }
      user.touch(:last_access_at)
      @current_user = user
    else
      request_http_token_authentication
    end
  end

  def set_request_format
    request.format = :json
  end

  def user_not_authorized
    head 403
  end
end