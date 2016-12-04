class V1::UsersController < V1::BaseController
  before_action :set_user, except: [:index, :create, :change_password, :search,:change_email]

  def index
    search_params = params[:q].present? ? params[:q] : nil
    q = User.active.without_externals.includes(:profile).ransack(search_params)
    @users = q.result
    if @users.class == Array
      @users = Kaminari.paginate_array(@users).page(params[:page]).per(params[:per_page])
    else
      @users = @users.page(params[:page]).per(params[:per_page]) # if @posts is AR::Relation object
    end
  end

  def search
    my_friends = current_user.my_friends.map(&:id)
    query = { query: {
        filtered: {
            query: params[:q][:query],
            filter: {
                not: {
                  terms: {
                    "user_id"=>my_friends
                  }
                }
            }
        }
      } 
    }
    @results= Profile.search(query).page(params[:page]).per(params[:per_page])
    user_ids = @results.results.to_a.map(&:user_id)
    @users = User.active.without_externals.includes(:profile).where(id: user_ids)
    if browser.platform.ios? || browser.platform.android? || browser.platform.other?
      render 'mobile/users'
    else
      render :index, status: :ok
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

  def change_email
    @user = User.find(params[:id])
    if @user
      if @user.update(email_params)
        render json: { message: "Email has been edit"}, status: :ok
      else
        render json: { errors: @user.errors }, status: :unprocessable_entity
      end
    else
      render json: { error: "invalid user"}, status: 401
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.permit(:email, :password, :password_confirmation, :avatar, :name, :member, :status)
  end

  def password_params
    params.permit(:id, :password, :password_confirmation)
  end

  def email_params
    params.permit(:id, :email)
  end

  def check_if_current_user_can_invite_on_group
    unless current_user.can_invite_on_group?(@group)
      render nothing: true, status: 401
    end
  end
end
