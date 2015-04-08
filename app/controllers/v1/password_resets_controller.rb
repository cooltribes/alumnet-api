class V1::PasswordResetsController < V1::BaseController
  skip_before_action :authenticate
  before_action :check_params, only: :create
  before_action :check_user, only: :update


  def create
    user = User.find_by(email: reset_params['email'])
    if user
      user.send_password_reset
      render json: { message: "We've sent you an email to reset your password!"}, status: :ok
    else
      render json: { errors: { email: ["not registered"] } }, status: 401
    end
  end

  def update
    if @user.password_reset_token_expired?
      render json: { errors: { token: ["has expired"]} }, status: 401
    elsif @user.update(update_params)
      render json: { message: "Password has been reset"}, status: :ok
    else
      render json: { errors: @user.errors }, status: 401
    end
  end

  private

  def check_params
    unless params[:email].present?
      render json: { errors: { email: ["Please enter your email address"] } }, status: 401
    end
  end

  def check_user
    unless @user = User.find_by(password_reset_token: params[:id])
      render json: { errors: { token: ["is invalid"] } }, status: 401
    end
  end

  def reset_params
    params.permit(:email)
  end

  def update_params
    params.permit(:password, :password_confirmation)
  end
end
