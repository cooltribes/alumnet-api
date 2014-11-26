class V1::Users::MembershipsController < V1::BaseController
  before_action :set_user
  before_action :set_membership, only: [:update, :destroy]
  before_action :set_and_check_group, only: :create

  def index
    @memberships = @user.memberships.pending
  end

  def groups
    @q = @user.memberships.accepted.search(params[:q])
    @memberships = @q.result
    render :index, status: :ok
  end

  def create
    @membership = @user.build_membership_for(@group)
    if @membership.save
      render :show, status: :created
    else
      render json: @membership.errors, status: :unprocessable_entity
    end
  end

  def update
    if @membership.update(membership_params)
      render :show
    else
      render json: @membership.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @membership.destroy
    head :no_content
  end

  private
    def set_user
      @user = User.find(params[:user_id])
    end

    def set_membership
      @membership = @user.memberships.find(params[:id])
    end

    def set_and_check_group
      unless @group = Group.find_by(id: params[:group_id])
        render json: { error: "Group not found" }
      end
    end

    def membership_params
      params.permit(:approved) ##TODO select the attributes for update
    end
end
