class V1::Profiles::LanguageLevelsController < V1::BaseController
  include Pundit
  before_action :set_profile
  before_action :set_language_level, except: [:index, :create]

  def index
    @language_levels = @profile.language_levels
  end

  def create
    @language_level = LanguageLevel.new(language_level_params)
    authorize @profile
    if @profile.language_levels << @language_level
      @profile.save_profinda_profile
      render :show, status: :created
    else
      render json: @language_level.errors, status: :unprocessable_entity
    end
  end

  def update
    authorize @profile
    if @language_level.update(language_level_params)
      @profile.save_profinda_profile
      render :show, status: :ok
    else
      render json: @language_level.errors, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @profile
    @language_level.destroy
    @profile.save_profinda_profile
    head :no_content
  end

  private

  def set_profile
    @profile = Profile.find(params[:profile_id])
  end

  def set_language_level
    @language_level = @profile.language_levels.find(params[:id])
  end

  def language_level_params
    params.permit(:language_id, :level)
  end

end
