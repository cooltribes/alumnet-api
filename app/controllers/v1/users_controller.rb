class V1::UsersController < V1::BaseController
  before_action :set_user, except: [:index, :create, :change_password, :search]

  def index
    q = User.active.without_externals.includes(:profile).ransack(params[:q])
    @users = q.result
    if @users.class == Array
      @users = Kaminari.paginate_array(@users).page(params[:page]).per(params[:per_page])
    else
      @users = @users.page(params[:page]).per(params[:per_page]) # if @posts is AR::Relation object
    end
  end

  def search
    user_ids = Profile.search(params[:q]).page(params[:page]).per(params[:per_page]).results.to_a.map(&:user_id)
    @users = User.active.without_externals.includes(:profile).where(id: user_ids)
    render :index, status: :ok
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

  def register_visit
    ###TODO: this should be in a callback on filter in the appropiate controller. :armando.
    ProfileVisit.create_visit(@user, current_user)
    head :no_content
  end

  def change_password
    @user = User.find(params[:id]).try(:authenticate, params[:current_password])
    if @user
      if @user.update(password_params)
        render json: { message: "Password has been reset"}, status: :ok
      else
        render json: { errors: @user.errors }, status: 401
      end
    else
      render json: { error: "incorrect current password"}, status: 401
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.permit(:email, :password, :password_confirmation, :avatar, :name, :member)
  end

  def password_params
    params.permit(:id, :password, :password_confirmation)
  end

  def check_if_current_user_can_invite_on_group
    unless current_user.can_invite_on_group?(@group)
      render nothing: true, status: 401
    end
  end
end
