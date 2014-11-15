class V1::UserController < V1::BaseController
  before_action :set_user

  def show
    render 'v1/users/show', status: :ok,  location: me_path
  end

  def update
    if @user.update(user_params)
      render 'v1/users/show', status: :ok,  location: me_path
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  private
    def user_params
      params.permit(:email, :password, :password_confirmation)
    end

    def set_user
      @user = current_user if current_user
    end
end