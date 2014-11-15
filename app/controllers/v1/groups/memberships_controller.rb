class V1::Groups::MembershipsController < V1::BaseController
  before_action :set_group
  before_action :set_membership, only: [:update, :destroy]
  before_action :set_and_check_user, only: :create

  def index
    @memberships = @group.memberships.pending
    render 'v1/shared/memberships/index'
  end

  def members
    @memberships = @group.memberships.accepted
    render 'v1/shared/memberships/index'
  end

  def create
    @membership = @group.build_membership_for(@user)
    if @membership.save
      render 'v1/shared/memberships/show', status: :created
    else
      render json: @membership.errors, status: :unprocessable_entity
    end
  end

  def update
    if @membership.update(membership_params)
      render 'v1/shared/memberships/show'
    else
      render json: @membership.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @membership.destroy
    head :no_content
  end

  private
    def set_group
      @group = Group.find(params[:group_id])
    end

    def set_membership
      @membership = @group.memberships.find(params[:id])
    end

    def set_and_check_user
      unless @user = User.find_by(id: params[:user_id])
        render json: { error: "User not found" }
      end
    end

    def membership_params
      params.permit(:approved) ##TODO select the attributes for update
    end
end
