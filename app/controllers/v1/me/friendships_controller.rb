class V1::Me::FriendshipsController < V1::BaseController
  before_action :set_user
  before_action :set_and_check_friend, only: :create

  def index
    @q = @user.get_pending_friendships(params[:filter], params[:q])
    @friendships = Kaminari.paginate_array(@q).page(params[:page]).per(params[:per_page])
  end

  def friends
    @q = @user.search_accepted_friends(params[:q])
    @friends = Kaminari.paginate_array(@q).page(params[:page]).per(params[:per_page])
  end

  def suggestions
    query = { m: 'or', profile_first_name_cont: params[:term], profile_last_name_cont: params[:term] }
    @friends = @user.search_accepted_friends(query)
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
    @friendship.accept!
    render :show
  end

  def destroy
    @friendship = Friendship.find(params[:id])
    # find notification to destroy
    notification = @friendship.friend.mailbox.notifications.joins(:notification_detail)
      .find_by(sender: @friendship.user, notification_details: {notification_type: ['friendship']})
    notification_detail = NotificationDetail.find_by(mailboxer_notification: notification)

    #destroy them all
    if notification_detail.present?
      notification_detail.destroy
    end
    notification.mark_as_deleted(@friendship.friend)
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
