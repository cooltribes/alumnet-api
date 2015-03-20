class V1::Users::FriendshipsController < V1::BaseController
  before_action :set_user
  before_action :set_current_user, only: :commons


  def index
    @friendships = @user.get_pending_friendships(params[:filter])
  end

  def friends
    @friends = if @user.permit('see-friends', current_user)
      @user.search_accepted_friends(params[:q])
    else
      []
    end
  end

  def commons
    friendsA = @current_u.search_accepted_friends(params[:q])
    friendsB = @user.search_accepted_friends(params[:q])
    @friends = friendsA & friendsB
  end

  private
    def set_user
      @user = User.find(params[:user_id])
    end
    def set_current_user
      @current_u = current_user if current_user
    end
end
