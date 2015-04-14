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
      render :show, status: :ok
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def activate
    if @user.active?
      render json: ["the user is already activated"], status: :unprocessable_entity
    else
      if @user.activate!
        render :show, status: :ok
      else
        render json: ['the register is incompleted!'], status: :unprocessable_entity
      end
    end
  end

  def banned
    if @user.active?
      @user.banned!
      render :show, status: :ok
    else
      render json: ["the user is already banned"]
    end
  end

  def change_role
    if params[:role] == "regular"
      @user.set_regular!
    else
      @user.set_admin_role(params)
    end
    render :show, status: :ok
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
end
