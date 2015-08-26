class V1::Admin::UsersController < V1::AdminController
  before_action :set_user, except: [:index, :stats, :register]

  def index
    if params[:tags].present?
      @users = User.includes(:profile).tagged_with(params[:tags])
    else
      @q = if @admin_location
        @admin_location.users.includes(:profile).search(params[:q])
      else
        User.includes(:profile).search(params[:q])
      end
      @users = @q.result
    end
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

  def groups
    @q = @user.groups.search(params[:q])
    @groups = @q.result
  end

  def events
    @q = @user.limit_attend_events.search(params[:q])
    @events = @q.result
  end

  def note
    if @user.set_admin_note(params[:note])
      render :show, status: :ok
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def activate
    service = ::Users::ActivateUser.new(@user, @mc)
    if service.call
      render :show, status: :ok
    else
      render json: service.errors, status: :unprocessable_entity
    end
  end

  def banned
    banned = AdminBannedUser.new(@user, @mc)
    if banned.valid?
      render :show, status: :ok
    else
      render json: banned.errors, status: :unprocessable_entity
    end
  end

  def change_role
    if params[:role] == "regular" || params[:role] == "external"
      @user.set_role(params[:role])
    else
      @user.set_admin_role(params)
    end
    render :show, status: :ok
  end

  def destroy
    if @user == current_user
      render json: ["you can't destroy yourself"]
    else
      @user.destroy
      @user.suspend_in_profinda
      head :no_content
    end
  end

  def register
    @user = User.create_from_admin(register_params)
    if @user.valid?
      @user.save_profinda_profile
      @user.send_password_reset
      render :show, status: :created
    else
      render json: { errors: @user.errors }, status: :unprocessable_entity
    end
  end

  def stats
    ##TODO: Refactor this
    @q = if @admin_location
      @admin_location.users.includes(:profile)
    else
      User.includes(:profile)
    end
    @all_users = @q.search().result
    @counters = Hash[
      "users_all", @all_users.count,
      "users", @all_users.where(member: 0).count,
      "members", @all_users.where(member: 1, member: 2).count,
      "lt_members", @all_users.where(member: 3).count,
    ]


    if params[:q] && params[:q] != ""
      @q = User.includes(:profile)
      query_users = @q.search(params[:q]).result
      @query_counters = Hash[
        "users_all", query_users.count,
        "users", query_users.where(member: 0).count,
        "members", query_users.where(member: 1, member: 2).count,
        "lt_members", query_users.where(member: 3).count,
      ]
    else
      @query_counters = nil
    end


  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.permit(:tag_list)
  end

  def register_params
    params.permit(:email, :role)
  end
end
