require 'mailchimp'
# TODO: Refactorizar mailchimp este controlador :yondry
class V1::GroupsController < V1::BaseController
  include Pundit
  before_action :set_group, except: [:index, :create, :search]

  def index
    @q = Group.without_secret.ransack(params[:q])
    @groups = @q.result
    #@groups = Kaminari.paginate_array(@groups).page(params[:page]).per(params[:per_page])
    if @groups.class == Array
      @groups = Kaminari.paginate_array(@groups).page(params[:page]).per(params[:per_page])
    else
      @groups = @groups.page(params[:page]).per(params[:per_page]) # if @posts is AR::Relation object
    end
  end

  def search
    group_ids = Group.search(params[:q]).page(params[:page]).per(params[:per_page]).results.to_a.map(&:id)
    @groups = Group.without_secret.where(id: group_ids)
    render :index, status: :ok
  end

  def picture
    render json: { error: "Not file given" }, status: :unprocessable_entity unless params.key?(:file)
    service = ::Pictures::CreatePicture.new(@group, current_user, params)
    if service.call
      @picture = service.picture
      render 'v1/pictures/show', status: :created
    else
      render json: service.errors, status: :unprocessable_entity
    end
  end

  def cropping
    @group.assign_attributes(crop_params)
    @group.crop('cover')
    render json: { status: 'success', url: @group.cover.crop.url }
  end

  def subgroups
    @q = @group.children.ransack(params[:q])
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
      if @group.mailchimp
        @mailchimp = MailchimpGroup.new(@group)
        if @mailchimp.valid?
          @group.save
          Membership.create_membership_for_creator(@group, current_user)
          render :show, status: :created,  location: @group
        else
          render json: { success: false, message: @mailchimp.errors }, status: :unprocessable_entity
        end
      else
        @group.save
        Membership.create_membership_for_creator(@group, current_user)
        render :show, status: :created,  location: @group
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
            member.subscribe_to_mailchimp_list(@mc_group, @group.list_id)
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

  def validate_mailchimp
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
          @mc_group.lists.activity(@group.list_id)
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
    params.permit(:name, :description, :short_description, :cover, :group_type, :official, :country_id,
      :city_id, :join_process, :mailchimp, :api_key, :list_id, :upload_files, :cover_position, picture_ids:[])
  end

  def crop_params
    params.permit(:imgInitH, :imgInitW, :imgW, :imgH, :imgX1, :imgY1, :cropW, :cropH)
  end
end