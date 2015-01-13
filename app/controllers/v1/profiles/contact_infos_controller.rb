class V1::Profiles::ContactInfosController < V1::BaseController
  include Pundit
  before_action :set_profile
  before_action :set_contact_info, except: [:index, :create]

  def index
    @contact_infos = @profile.contact_infos
  end

  def create
    @contact_info = ContactInfo.new(contact_info_params)
    authorize @profile
    if @profile.contact_infos << @contact_info
      render :show, status: :created
    else
      render json: @contact_info.errors, status: :unprocessable_entity
    end
  end

  def update
    authorize @profile
    if @contact_info.update(contact_info_params)
      render :show, status: :ok
    else
      render json: @contact_info.errors, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @profile
    @contact_info.destroy
    head :no_content
  end

  private

  def set_profile
    @profile = Profile.find(params[:profile_id])
  end

  def set_contact_info
    @contact_info = @profile.contact_infos.find(params[:id])
  end

  def contact_info_params
    params.permit(:contact_type, :info, :privacy)
  end

end
