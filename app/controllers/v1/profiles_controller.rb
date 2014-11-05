class V1::ProfilesController < V1::BaseController
  before_action :set_user
  before_action :set_profile

  def show
  end

  def update
    if @profile.update(profile_params)
      render :show, status: :ok
    else
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
      params.permit(:first_name, :last_name, :avatar, :born, :register_step)
    end
end