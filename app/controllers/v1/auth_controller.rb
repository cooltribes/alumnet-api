class V1::AuthController < V1::BaseController
  skip_before_action :authenticate
  before_action :check_params, only: [:sign_in]

  def sign_in
    email, password = params[:email].downcase, params[:password]
    @user = User.find_by(email: email).try(:authenticate, password)
    if @user
      @user.register_sign_in
      add_provider
    else
      render json: { error: "email or password are incorrect"}, status: 401
    end
  end

  def oauth_sign_in
    @provider = OauthProvider.find_by(provider_params)
    if @provider
      @user = @provider.user
      @user.register_sign_in
      render :user, status: :ok, location: @user
    else
      render json: { error: "email or password are incorrect"}, status: 401
    end
  end

  def register
    @user = User.new(user_params)
    if @user.save
      validate_register_points(params[:invitation_token]) if params[:invitation_token].present?
      render :user, status: :created,  location: @user
    else
      render json: { errors: @user.errors }, status: :unprocessable_entity
    end
  end

  def oauth_register
    @user = User.new(oauth_register_params)
    if @user.save
      validate_register_points(params[:invitation_token]) if params[:invitation_token].present?
      render :user, status: :created,  location: @user
    else
      render json: { errors: @user.errors }, status: :unprocessable_entity
    end
  end

  def mobile_register
    service = ::Registers::MobileRegister.new(mobile_register_params)
    if service.call
      @user = service.user
      render :user, status: :created
    else
      render json: { errors: service.errors }, status: :unprocessable_entity
    end
  end

  private

  def add_provider
    if params[:provider].present? && params[:uid].present?
      provider = OauthProvider.new(provider_params)
      if @user.oauth_providers << provider
        render :user, status: :ok,  location: @user
      else
        render json: { error: provider.errors }, status: 401
      end
    else
      render :user, status: :ok,  location: @user
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

    # profile:[:first_name, :last_name, :born, :residence_city_id],
  def mobile_register_params
    params.permit(user: [:email, :password], experience: [:start_date, :end_date, :country_id, :committee_id])
  end

  def validate_register_points(token)
    action = Action.find_by(key_name: 'accepted_invitation')
    if action.present? && action.status == "active"
      invitation = Invitation.find_by(token: token)
      if invitation
        invitation.accept!(@user)
        inviter = invitation.user
        ###TODO: Refactor this
        if inviter.is_admin?
          @user.update_column(:created_by_admin, true)
        else
          inviter.profile.add_points(action.value)
          UserAction.create(value: action.value, generator_id: invitation.id, generator_type: action.key_name, user_id: inviter.id, action_id: action.id)
        end
      end
    end
  end
end
