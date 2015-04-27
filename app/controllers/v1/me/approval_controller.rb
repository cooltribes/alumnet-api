class V1::Me::ApprovalController < V1::BaseController
  before_action :set_user
  before_action :set_and_check_approver, only: :create

  def index
    @requests = @user.get_pending_approval_requests
  end


  def create
    @approval_request = @user.create_approval_request_for(@approver)
    if @approval_request.save
      # Notification.notify_friendship_request_to_user(@user, @friend)
      render :show, status: :created
    else
      render json: @approval_request.errors, status: :unprocessable_entity
    end
  end

  def update
    @approval_request = @user.pending_approval_requests.find(params[:id])
    #if @friendship.friend_id == current_user.id #this a policy refactor!
    @approval_request.accept!

    requester = @approval_request.user

    if requester.get_approved_requests.count == 3
      requester.activate!

    #Create a friendship between users
    friendship = requester.create_friendship_for(@user)

    if friendship.save
      friendship.accept!
      # Notification.notify_friendship_request_to_user(@user, @friend)
      #Notificate for a new friendship created but not accepted
      render :show
    else
      render json: friendship.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @approval_request = ApprovalRequest.find(params[:id])
    #if @friendship.friend_id == current_user.id || @friendship.user_id == current_user.id
    @approval_request.destroy
    head :no_content
  end

  private
    def set_user
      @user = current_user if current_user
    end

    def set_and_check_approver
      unless @approver = User.find_by(id: params[:approver_id])
        render json: { error: "User not found" }
      end
    end
end
