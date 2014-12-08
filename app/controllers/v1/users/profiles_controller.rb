class V1::Users::ProfilesController < V1::BaseController
  before_action :set_user
  before_action :set_profile

  def show
  end

  def update
    if @profile.update(profile_params)
      render :show
    else
      byebug
      render json: @profile.errors, status: :unprocessable_entity
    end
  end

  private
    def set_user
      @user = User.find(params[:user_id])
    end

    def set_profile
      @profile = @user.profile
    end

    def profile_params
      params.permit(:first_name, :last_name, :avatar, :born, :birth_city, :residence_city,
        :bird_country, :residence_country)
    end
end