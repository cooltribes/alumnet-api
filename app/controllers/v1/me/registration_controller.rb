class V1::Me::RegistrationController < V1::BaseController
  before_action :set_user
  before_action :set_profile
  before_action :set_current_step

  def show
    render json: { current_step: @current_step }
  end

  def update
    @profile.update_next_step
    render json: { current_step: @profile.register_step }
  end

  def step
    if register_step[:register_step].present?
      @profile.register_step = register_step[:register_step]
      @profile.save
    end
    render json: { current_step: @profile.register_step }
  rescue
    render json: { errors: ["is not a valid register_step"] }, status: :unprocessable_entity
  end

  private
    def set_user
      @user = current_user if current_user
    end

    def set_profile
      @profile = @user.profile
    end

    def register_step
      params.permit(:register_step)
    end

    def set_current_step
      @current_step = params[:register_step] || @profile.register_step
    end
end