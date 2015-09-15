class V1::ProfilesController < V1::BaseController
  include Pundit
  before_action :set_profile

  def show
  end

  def cropping
    image = params[:image]
    @profile.assign_attributes(crop_params)
    @profile.crop(image)
    render json: { status: 'success', url: @profile.crop_url(image) }
  end

  def update
    authorize @profile
    if @profile.update(profile_params)
      @profile.save_profinda_profile
      @profile.user.subscribe_to_mailchimp_list(@mc, Settings.mailchimp_general_list_id)
      @profile.user.update_groups_mailchimp()
      render :show
    else
      render json: @profile.errors, status: :unprocessable_entity
    end
  end

  private
    def set_profile
      @profile = Profile.find(params[:id])
    end

    def profile_params
      params.permit(:first_name, :last_name, :avatar, :born, :birth_city_id, :residence_city_id,
        :birth_country_id, :residence_country_id, :gender, :cover)
    end

    def crop_params
      params.permit(:imgInitH, :imgInitW, :imgW, :imgH, :imgX1, :imgY1, :cropW, :cropH, :image)
    end
end