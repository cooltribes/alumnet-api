class V1::AuthController < V1::BaseController
  skip_before_action :authenticate
  before_action :check_params, only: :sign_in

  def sign_in
    email, password = params[:email], params[:password]
    @user = User.find_by(email: email).try(:authenticate, password)
    if @user
      render :user, status: :ok,  location: @user
    else
      render json: { error: "email or password are incorrect"} , status: 401
    end
  end

  def register
    @user = User.new(user_params)
    if @user.save
      @user.profile.update(profile_params)
      render :user, status: :created,  location: @user
    else
      render json: { errors: @user.errors }, status: :unprocessable_entity
    end
  end

  private

  def check_params
    unless params[:email].present? && params[:password].present?
      render json: { error: "must provide credentials" } , status: 401
    end
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def profile_params
    params.require(:profile).permit(:first_name, :last_name)
  end
end
