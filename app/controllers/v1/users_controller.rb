class V1::UsersController < V1::BaseController
  before_filter :set_user, except: [:index, :create]
  before_filter :set_group, only: :invite
  before_filter :check_if_current_user_can_invite_on_group, only: :invite

  def index
    @users = User.all
  end

  def show
  end

  def create
    @user = User.new(user_params)
    if @user.save
      render :show, status: :created,  location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      render :show, status: :ok,  location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    head :no_content
  end

  def invite
    unless membership = Membership.find_by(user_id: @user, group_id: @group.id)
      Membership.create_membership_for_invitation(@group, @user)
      render json: { user_id: @user.id, group_id: @group.id }
    else
      render json: { error: "User has already invited" }, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def set_group
    @group = Group.find(params[:group_id])
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
