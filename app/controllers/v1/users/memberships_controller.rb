require 'mailchimp'

class V1::Users::MembershipsController < V1::BaseController
  before_action :set_user
  before_action :set_membership, only: [:update, :destroy]
  before_action :set_and_check_group, only: :create

  def index
    @memberships = @user.memberships.pending
  end

  def groups
    q = @user.memberships.accepted.ransack(params[:q])
    @memberships = q.result.joins(:group).order('groups.name').page(params[:page]).per(params[:per_page])
    if browser.platform.ios? || browser.platform.android? || browser.platform.other?
      render 'mobile/memberships_groups'
    else
      render :index, status: :ok
    end
  end

  def created_groups
    q = @user.memberships.where_user_is_admin(@user).ransack(params[:q])
    @memberships = q.result.page(params[:page]).per(params[:per_page])
    if browser.platform.ios? || browser.platform.android? || browser.platform.other?
      render 'mobile/memberships_groups'
    else
      render :index, status: :ok
    end
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
    email = @membership.user.email
    group = @membership.group
    @membership.really_destroy!
    if group.mailchimp
      @mc_group = Mailchimp::API.new(group.api_key)
      @mc_group.lists.unsubscribe(group.list_id, {'email' => email}, false, false, true)
    end
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
