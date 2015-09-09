class V1::Me::RegistrationController < V1::BaseController
  before_action :set_user
  before_action :set_profile
  before_action :set_current_step

  def show
    ## require create a json with a name of step in v1/me/registration
    render json: { current_step: @current_step }
  end

  def update
    ## require create a private method with the name of step. The logic of update and render must be there.
    send @current_step
  end

  private
    def set_user
      @user = current_user if current_user
    end

    def set_profile
      @profile = @user.profile
    end

    def set_current_step
      @current_step = params[:register_step] || @profile.register_step
    end

    def initial
      if @profile.update(profile_params)
        @profile.update_step
        render @current_step
      else
        render json: @profile.errors, status: :unprocessable_entity
      end
    end
end