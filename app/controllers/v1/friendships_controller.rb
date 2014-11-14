class V1::FriendshipsController < V1::BaseController
  before_action :set_and_check_user, only: :create

  def index
    @friendships = current_user.find_pending_friendships(params[:filter])
    @friendship_type = params[:filter]
  end

  def create
    @friendship = current_user.add_to_friends(@user)
    if @friendship.save
      render :show, status: :created
    else
      render json: @friendship.errors, status: :unprocessable_entity
    end
  end

  def update
    @friendship = current_user.pending_inverse_friendships.find(params[:id])
    @friendship.accept! #if @friendship.friend_id == current_user.id #this a policy refactor!
    render :show, status: :ok
  end

  private
    def set_and_check_user
      unless @user = User.find_by(id: params[:friend_id])
        render json: { error: "User not found" }
      end
    end

end
