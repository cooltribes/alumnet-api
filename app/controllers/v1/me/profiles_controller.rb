class V1::Me::ProfilesController < V1::BaseController
  before_action :set_user
  before_action :set_profile

  def show
    render 'v1/shared/profiles/show'
  end

  def update
    if @profile.update(profile_params)
      @profile.update_step
      render 'v1/shared/profiles/show'
    else
      render json: @profile.errors, status: :unprocessable_entity
    end
  end

  private
    def set_user
      @user = current_user if current_user
    end

    def set_profile
      @profile = @user.profile
    end

    def profile_params
      if @profile.initial?
        params.permit(:first_name, :last_name, :avatar, :born, :birth_city, :residence_city)
      elsif @profile.profile?
        params.permit(contact_infos_attributes: [:contact_type, :info, :privacy])
      end
    end
end