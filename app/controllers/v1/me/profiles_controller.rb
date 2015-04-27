class V1::Me::ProfilesController < V1::BaseController
  before_action :set_user
  before_action :set_profile

  def show
  end

  def update
    if @profile.update(profile_params)
      @profile.update_step
      render :show
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
        params.permit(:first_name, :last_name, :avatar, :born, :birth_city_id, :residence_city_id,
          :birth_country_id, :residence_country_id, :gender, :avatar_url)
      elsif @profile.profile?
        params.permit(contact_infos_attributes: [:contact_type, :info, :privacy])
      elsif @profile.contact? || @profile.experience_a?
        params.permit(experiences_attributes: [:exp_type, :name, :description, :start_date,
          :end_date, :city_id, :country_id, :aiesec_experience, :committee_id])
      elsif @profile.experience_b?
        params.permit(experiences_attributes: [:exp_type, :name, :description, :start_date,
          :end_date, :city_id, :country_id, :organization_name, :aiesec_experience, :committee_id])
      elsif @profile.experience_c?
        params.permit(experiences_attributes: [:exp_type, :name, :description, :start_date,
          :end_date, :city_id, :country_id, :organization_name, :internship, :committee_id])
      elsif @profile.experience_d?
        params.permit(languages_attributes: [:language_id, :level], skills_attributes: [])
      end
    end
end