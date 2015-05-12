require 'mailchimp'

class V1::GroupsController < V1::BaseController
  include Pundit
  before_action :set_group, except: [:index, :create]

  def index
    @q = Group.without_secret.search(params[:q])
    @groups = @q.result
  end

  def cropping
    @group.assign_attributes(crop_params)
    @group.crop
    render json: { status: 'success', url: @group.cover.crop.url }
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
    @group.creator = current_user
    @group.cover_uploader = current_user
    if @group.save
      Membership.create_membership_for_creator(@group, current_user)
      if @group.mailchimp
        @mc_group = Mailchimp::API.new(@group.api_key)
        @mc_group.lists.subscribe(@group.list_id, {'email' => current_user.email}, nil, 'html', false, true, true, true)
      end
      render :show, status: :created,  location: @group
    else
      render json: @group.errors, status: :unprocessable_entity
    end
  end

  def add_group
    @new_group = Group.new(group_params)
    @new_group.creator = current_user
    @new_group.cover_uploader = current_user
    if @group.children << @new_group
      Membership.create_membership_for_creator(@new_group, current_user)
      render :add_group, status: :created,  location: @group
    else
      render json: @new_group.errors, status: :unprocessable_entity
    end
  end

  def update
    authorize @group
    @group.cover_uploader = current_user
    if @group.update(group_params)
      render :show, status: :ok,  location: @group
    else
      render json: @group.errors, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @group
    @group.destroy
    head :no_content
  end

  def migrate_users
    render json: @group
  end

  private

  def set_group
    @group = Group.find(params[:id])
  end

  def group_params
    params.permit(:name, :description, :cover, :group_type, :official, :country_id,
      :city_id, :join_process, :mailchimp, :api_key, :list_id)
  end

  def crop_params
    params.permit(:imgW, :imgH, :imgX1, :imgY1, :cropW, :cropH)
  end

end
