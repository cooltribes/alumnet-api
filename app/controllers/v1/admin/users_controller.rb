class V1::Admin::UsersController < V1::AdminController
  before_action :set_user, except: [:index, :stats]

  def index
    @q = if @admin_location
      @admin_location.users.includes(:profile).search(params[:q])
    else
      User.includes(:profile).search(params[:q])
    end
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
        @mc.lists.subscribe(Settings.mailchimp_general_list_id, {'email' => @user.email}, nil, 'html', false, true, true, true)
        render :show, status: :ok
      else
        render json: ['the register is incompleted!'], status: :unprocessable_entity
      end
    end
  end

  def banned
    if @user.active?
      @user.banned!
      @user.suspend_in_profinda
      valid = true
      begin
        @mc.lists.unsubscribe(Settings.mailchimp_general_list_id, {'email' => @user.email}, false, false, true)
      rescue Mailchimp::EmailNotExistsError
        valid = false
      end
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
    if @user == current_user
      render json: ["you can't destroy yourself"]
    else
      @user.destroy
      head :no_content
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
    params.permit(:email, :password, :password_confirmation)
  end
end
