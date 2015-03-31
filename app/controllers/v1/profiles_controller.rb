class V1::ProfilesController < V1::BaseController
  include Pundit
  before_action :set_profile

  def show
  end

  def cropping
    @profile.assign_attributes(crop_params)
    @profile.crop_avatar
    render json: { status: 'success', url: @profile.avatar.crop.url }
  end

  def update
    authorize @profile
    if @profile.update(profile_params)
      render :show
    else
      render json: @profile.errors, status: :unprocessable_entity
    end
  end

  private
    def set_profile
      @profile = Profile.find(params[:id])
    end

    def profile_params
      params.permit(:first_name, :last_name, :avatar, :born, :birth_city_id, :residence_city_id,
          :birth_country_id, :residence_country_id, :gender)
    end

    def crop_params
      params.permit(:imgW, :imgH, :imgX1, :imgY1, :cropW, :cropH)
    end
end