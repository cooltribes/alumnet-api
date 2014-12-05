class V1::GroupsController < V1::BaseController
  before_action :set_group, except: [:index, :create]

  def index
    @q = Group.search(params[:q])
    @groups = @q.result
  end

  def subgroups
    @q = @group.children.search(params[:q])
    @groups = @q.result
    render :index, status: :ok
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
    @new_group.creator_user_id = current_user.id
    if @group.children << @new_group
      Membership.create_membership_for_creator(@new_group, current_user)
      render :add_group, status: :created,  location: @group
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

  private

  def set_group
    @group = Group.find(params[:id])
  end

  def group_params
    params.permit(:name, :description, :cover, :group_type, :official, :country_id,
      :city_id)
  end

end
