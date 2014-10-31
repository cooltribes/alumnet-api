class V1::AuthController < V1::BaseController
  skip_before_action :authenticate
  before_action :check_params

  def sign_in
    email, password = params[:email], params[:password]
    unless @user = User.find_by(email: email).try(:authenticate, password)
      render json: { error: "email or password are incorrect"} , status: 401
    end
  end

  private

  def check_params
    unless params[:email].present? && params[:password].present?
      render json: { error: "must provide credentials" } , status: 401
    end
  end
end
