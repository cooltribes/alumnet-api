class V1::PublicProfilesController < V1::BaseController
  skip_before_action :authenticate
  before_action :set_guest  

  def show
    @user = User.find_by(slug: params[:slug])
    unless @user
      render json: { error: "User not found" }, status: 404
    end
  end


  private
    def set_guest
      guest = User.new()
      @current_user = guest
    end
  


end
