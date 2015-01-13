class V1::Profiles::ExperiencesController < V1::BaseController
  include Pundit
  before_action :set_profile
  before_action :set_experience, except: [:index, :create]

  def index
    @experiences = @profile.experiences
  end

  def create
    @experience = Experience.new(experience_params)
    authorize @profile
    if @profile.experiences << @experience
      render :show, status: :created
    else
      render json: @experience.errors, status: :unprocessable_entity
    end
  end

  def update
    authorize @profile
    if @experience.update(experience_params)
      render :show, status: :ok
    else
      render json: @experience.errors, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @profile
    @experience.destroy
    head :no_content
  end

  private

  def set_profile
    @profile = Profile.find(params[:profile_id])
  end

  def set_experience
    @experience = @profile.experiences.find(params[:id])
  end

  def experience_params
    params.permit(:exp_type, :name, :description, :start_date, :end_date, :city_id,
      :country_id, :organization_name, :internship, :committee_id)
  end

end