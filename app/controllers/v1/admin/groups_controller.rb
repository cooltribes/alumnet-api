class V1::Admin::GroupsController < V1::AdminController
  before_action :set_group, except: [:index, :create]

  def index
    @q = Group.search(params[:q])
    @groups = @q.result
  end

  def show
  end

  def subgroups
    @q = @group.children.search(params[:q])
    @groups = @q.result
    render :index, status: :ok
  end

  def create
    @group = Group.new(group_params)
    @group.creator = current_user
    if @group.save
      Membership.create_membership_for_creator(@group, current_user)
      render :show, status: :created,  location: @group
    else
      render json: @group.errors, status: :unprocessable_entity
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
      :city_id, :join_process, :parent_id)
  end
end
