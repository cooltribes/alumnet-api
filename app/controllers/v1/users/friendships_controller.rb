class V1::Users::FriendshipsController < V1::BaseController
  before_action :set_user

  def index
    @friendships = @user.get_pending_friendships(params[:filter])
  end

  def friends
    @friends = @user.search_accepted_friends(params[:q])
  end

  def commons
  end

  private
    def set_user
      @user = User.find(params[:user_id])
    end
end
