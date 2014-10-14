class V1::GroupsController < V1::BaseController
  before_filter :set_group, except: [:index, :create]

  def index
    @groups = Group.all
  end

  def show
  end

  def create
    @group = Group.new(group_params)
    if @group.save
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

  private

  def set_group
    @group = Group.find(params[:id])
  end

  def group_params
    params.permit(:name, :description, :avatar, :group_type)
  end

end
