class V1::AuthController < V1::BaseController
  skip_before_action :authenticate
  before_action :check_params, only: [:sign_in]

  def sign_in
    email, password = params[:email], params[:password]
    @user = User.find_by(email: email).try(:authenticate, password)
    if @user
      add_provider
      render :user, status: :ok,  location: @user
    else
      render json: { error: "email or password are incorrect"}, status: 401
    end
  end

  def oauth_sign_in
    @provider = OauthProvider.find_by(provider_params)
    if @provider
      @user = @provider.user
      render :user, status: :ok, location: @user
    else
      render json: { error: "email or password are incorrect"}, status: 401
    end
  end

  def register
    @user = User.new(user_params)
    if @user.save
      render :user, status: :created,  location: @user
    else
      render json: { errors: @user.errors }, status: :unprocessable_entity
    end
  end

  def oauth_register
    @user = User.new(oauth_register_params)
    if @user.save
      render :user, status: :created,  location: @user
    else
      render json: { errors: @user.errors }, status: :unprocessable_entity
    end
  end

  private

  def add_provider
    if params[:provider].present? && params[:uid].present?
      unless @user.oauth_providers << OauthProvider.new(provider_params)
        render json: { error: provider.errors }, status: 401
      end
    end
  end

  def check_params
    unless params[:email].present? && params[:password].present?
      render json: { error: "Please enter your email address and your password" } , status: 401
    end
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def oauth_register_params
    params.require(:user).permit(:email, :password, :password_confirmation,
      oauth_providers_attributes: [:provider, :uid])
  end

  def provider_params
    params.permit(:provider, :uid)
  end

end
