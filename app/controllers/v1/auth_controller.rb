class V1::AuthController < V1::BaseController
  skip_before_action :authenticate
  before_action :check_params, only: :sign_in

  def sign_in
    email, password = params[:email], params[:password]
    unless @user = User.find_by(email: email).try(:authenticate, password)
      render json: { error: "email or password are incorrect"} , status: 401
    end
  end

  def register
    @user = User.new(user_params)
    if @user.save
      render :register, status: :created,  location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  private

  def check_params
    unless params[:email].present? && params[:password].present?
      render json: { error: "must provide credentials" } , status: 401
    end
  end

  def user_params
    params.permit(:email, :password, :password_confirmation, :name)
  end
end
