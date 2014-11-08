class V1::GroupsController < V1::BaseController
  before_action :set_group, except: [:index, :create]

  def index
    @q = Group.search(params[:q])
    @groups = @q.result
  end

  def members
    @q = @group.members.search(params[:q])
    @members = @q.result
  end

  def show
  end

  def create
    @group = Group.new(group_params)
    @group.creator_user_id = current_user.id
    if @group.save
      Membership.create_membership_for_creator(@group, current_user)
      render :show, status: :created,  location: @group
    else
      render json: @group.errors, status: :unprocessable_entity
    end
  end

  def add_group
    @new_group = Group.new(group_params)
    if @group.children << @new_group
      render :show, status: :created,  location: @group
    else
      render json: @new_group.errors, status: :unprocessable_entity
    end
  end

  def update
    if @group.update(group_params)
      render :show, status: :ok,  location: @group
    else
      render json: @group.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @group.destroy
    head :no_content
  end

  def join
    unless membership = Membership.find_by(user_id: current_user.id, group_id: @group.id)
      Membership.create_membership_for_request(@group, current_user)
      render json: { user_id: current_user.id, group_id: @group.id }
    else
      render json: { error: "User has already join" }, status: :unprocessable_entity
    end
  end

  private

  def set_group
    @group = Group.find(params[:id])
  end

  def group_params
    params.permit(:name, :description, :cover, :group_type, :official)
  end

end
