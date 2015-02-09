class V1::Me::FriendshipsController < V1::BaseController
  before_action :set_user
  before_action :set_and_check_friend, only: :create

  def index
    @friendships = @user.get_pending_friendships(params[:filter])
  end

  def friends
    @friends = @user.search_accepted_friends(params[:q])
  end

  def create
    @friendship = @user.create_friendship_for(@friend)
    if @friendship.save
      Notification.notify_friendship_request_to_user(@user, @friend)
      render :show, status: :created
    else
      render json: @friendship.errors, status: :unprocessable_entity
    end
  end

  def update
    @friendship = @user.pending_inverse_friendships.find(params[:id])
    #if @friendship.friend_id == current_user.id #this a policy refactor!
    @friendship.accept!
    render :show
  end

  def destroy
    @friendship = Friendship.find(params[:id])
    #if @friendship.friend_id == current_user.id || @friendship.user_id == current_user.id
    @friendship.destroy
    head :no_content
  end

  private
    def set_user
      @user = current_user if current_user
    end

    def set_and_check_friend
      unless @friend = User.find_by(id: params[:friend_id])
        render json: { error: "User not found" }
      end
    end
end
