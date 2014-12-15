class V1::Admin::UsersController < V1::AdminController
  before_action :set_user, except: :index

  def index
    @q = User.includes(:profile).search(params[:q])
    @users = @q.result
  end

  def show
  end

  def update
    if @user.update(user_params)
      render :show, status: :ok,  location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def activate
    if @user.activate!
      render :show, status: :ok,  location: @user
    else
      render json: ['the register is incompleted!'], status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    head :no_content
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.permit(:email, :password, :password_confirmation)
  end

  def check_if_current_user_can_invite_on_group
    unless current_user.can_invite_on_group?(@group)
      render nothing: true, status: 401
    end
  end
end