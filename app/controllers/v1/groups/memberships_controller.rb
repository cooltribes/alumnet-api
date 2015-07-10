require 'mailchimp'

class V1::Groups::MembershipsController < V1::BaseController
  before_action :set_group
  before_action :set_membership, only: [:update, :destroy]
  before_action :set_and_check_user, only: :create

  def index
    @memberships = @group.memberships.pending
  end

  def members
    @q = @group.memberships.accepted.search(params[:q])
    @memberships = @q.result
    render :index
  end

  def create
    admin_flag = @group.user_is_admin?(current_user)
    @membership = @group.build_membership_for(@user, admin_flag)
    if @membership.save
      @group.notify(@user, current_user, admin_flag)
      if @group.mailchimp && (@group.join_process == 0 || admin_flag)
        @mc_group = Mailchimp::API.new(@group.api_key)
        @user.subscribe_to_mailchimp_list(@mc_group, @group.list_id)
      end
      render :show, status: :created
    else
      render json: @membership.errors, status: :unprocessable_entity
    end
  end

  def update
    if @membership.update(membership_params)

      Notification.notify_group_join_accepted_to_user(@membership.user, @group)

      if @group.mailchimp
        if @membership.approved
          @mc_group = Mailchimp::API.new(@group.api_key)
          @membership.user.subscribe_to_mailchimp_list(@mc_group, @group.list_id)
        else
          @mc_group.lists.unsubscribe(@group.list_id, {'email' => @membership.user.email}, false, false, true)
        end
      end
      render :show
    else
      render json: @membership.errors, status: :unprocessable_entity
    end
  end

  def destroy
    email = @membership.user.email
    @membership.really_destroy!
    if @group.mailchimp
      @mc_group = Mailchimp::API.new(@group.api_key)
      @mc_group.lists.unsubscribe(@group.list_id, {'email' => email}, false, false, true)
    end
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
      if @group.user_is_admin?(current_user)
        params.permit(:approved, :edit_group, :create_subgroup, :delete_member,
          :change_join_process, :moderate_posts, :make_admin )
      else
        params.permit(:approved)
      end
    end
end
