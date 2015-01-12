class V1::Profiles::SkillsController < V1::BaseController
  before_action :set_profile
  before_action :set_skill, except: [:index, :create]

  def index
    @skills = @profile.skills
  end

  def create
    @skill = Skill.new(skill_params)
    if @profile.skills << @skill
      render :show, status: :created
    else
      render json: @skill.errors, status: :unprocessable_entity
    end
  end

  def update
    if @skill.update(skill_params)
      render :show, status: :ok
    else
      render json: @skill.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @skill.destroy
    head :no_content
  end

  private

  def set_profile
    @profile = Profile.find(params[:profile_id])
  end

  def set_skill
    @skill = @profile.skills.find(params[:id])
  end

  def skill_params
    params.permit(:name)
  end

end
