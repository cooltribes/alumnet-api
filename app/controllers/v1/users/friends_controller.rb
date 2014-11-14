class V1::Users::FriendsController < V1::BaseController
  before_action :set_user

  def index
    @friends = @user.search_friends(params[:q])
  end

  private
    def set_user
      @user = User.find(params[:user_id])
    end
end