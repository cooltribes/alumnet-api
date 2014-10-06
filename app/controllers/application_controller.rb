class ApplicationController < ActionController::API
  include ActionController::ImplicitRender
  include ActionController::HttpAuthentication::Token::ControllerMethods

  before_filter :authenticate
  before_filter :set_request_format


  protected

  def current_user
    @current_user
  end

  def authenticate
    if user = authenticate_with_http_token { |t, o| User.find_by(api_token: t) }
      @current_user = user
    else
      request_http_token_authentication
    end
  end

  def set_request_format
    request.format = :json
  end

end
