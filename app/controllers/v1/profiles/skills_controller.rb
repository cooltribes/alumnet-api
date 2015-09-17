class V1::Profiles::SkillsController < V1::BaseController
  include Pundit
  before_action :set_profile
  before_action :set_skill, except: [:index, :create]

  def index
    @skills = @profile.skills
    render :index
  end

  def create
    authorize @profile
    service = ::Users::UpdateProfileSkills.new(@profile, params[:skill_names])
    if service.call
      @profile.save_profinda_profile
      index
    else
      render json: service.errors, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @profile
    @profile.skills.destroy(@skill)
    @profile.save_profinda_profile
    head :no_content
  end

  private

  def set_profile
    @profile = Profile.find(params[:profile_id])
  end

  def set_skill
    @skill = @profile.skills.find(params[:id])
  end
end
