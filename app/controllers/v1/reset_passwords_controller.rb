class V1::ResetPasswordsController < V1::BaseController
  skip_before_action :authenticate
  before_action :check_params, only: :create

  def create
    user = User.find_by(email: reset_params['email'])
    if user
      user.send_password_reset
      render json: { message: "Email sent with password reset instructions"}, status: :ok
    else
      render json: { error: "email not registered" }, status: 401
    end
  end

  private

  def check_params
    byebug
    unless params[:email].present?
      render json: { error: "must provide credentials" }, status: 401
    end
  end

  def reset_params
    params.permit(:email)
  end

end
