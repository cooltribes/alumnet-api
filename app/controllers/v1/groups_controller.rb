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
    if @group.valid?
      @mailchimp = MailchimpGroup.new(@group)
      if @mailchimp.valid?
        @group.save
        Membership.create_membership_for_creator(@group, current_user)
        render :show, status: :created,  location: @group
      else
        render json: { success: false, message: @mailchimp.errors }, status: :unprocessable_entity
      end
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
    if @group.mailchimp
      success = true
      message = 'No error'
      begin
        @mc_group = Mailchimp::API.new(@group.api_key)
      rescue Mailchimp::InvalidApiKeyError
        success = false
      end

      if success
        begin
          @group.members.each do |member|
            @mc_group.lists.subscribe(@group.list_id, {'email' => member.email}, nil, 'html', false, true, true, true)
          end
        rescue Mailchimp::ListDoesNotExistError
          success = false
          message = 'List does not exist'
        rescue Mailchimp::Error => ex
          success = false
          if ex.message
            message = ex.message
          else
            message = "An unknown error occurred"
          end
        end
        render json: { success: success, message: message }
      else
        render json: { success: false,  message: 'Invalid API Key' }
      end
    else
      render json: { success: false,  message: 'Group does not have mailchimp' }
    end
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