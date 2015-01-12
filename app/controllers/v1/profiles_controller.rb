class V1::ProfilesController < V1::BaseController
  before_action :set_profile

  def show
  end

  def update
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
end