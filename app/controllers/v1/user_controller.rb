class V1::UserController < V1::BaseController
  before_action :set_me
  before_action :set_profile

  def me
    render 'v1/users/show', status: :ok,  location: me_path
  end

  def profile
    render 'v1/profiles/show', status: :ok,  location: me_profile_path
  end

  def update_profile
    if @profile.update(profile_params)
      @profile.update_step
      render 'v1/profiles/show', status: :ok
    else
      render json: @profile.errors, status: :unprocessable_entity
    end
  end

  private

    def set_me
      @user = current_user if current_user
    end

    def set_profile
      @profile = @user.profile if @user
    end

    def profile_params
      params.permit(:first_name, :last_name, :avatar, :born, :birth_city, :residence_city, :register_step)
    end
end