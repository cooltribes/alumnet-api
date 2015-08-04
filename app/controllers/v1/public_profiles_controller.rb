class V1::PublicProfilesController < V1::BaseController
  skip_before_action :authenticate

  def show
    @user = User.find_by(slug: params[:slug])
    render json: @user
  end
end
