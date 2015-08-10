class V1::UsersController < V1::BaseController
  before_action :set_user, except: [:index, :create]

  def index
    @q = User.active.without_externals.includes(:profile).search(params[:q])
    @users = @q.result
    if @users.class == Array
      @users = Kaminari.paginate_array(@users).page(params[:page]).per(params[:per_page]) 
    else
      @users = @users.page(params[:page]).per(params[:per_page]) # if @posts is AR::Relation object 
    end    
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

  def destroy
    if @user == current_user
      render json: ["you can't destroy yourself"], status: :unprocessable_entity
    else
      @user.destroy
      @user.suspend_in_profinda
      head :no_content
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.permit(:email, :password, :password_confirmation, :avatar, :name)
  end

  def check_if_current_user_can_invite_on_group
    unless current_user.can_invite_on_group?(@group)
      render nothing: true, status: 401
    end
  end
end
