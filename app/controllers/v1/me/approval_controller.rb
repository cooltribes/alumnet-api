class V1::Me::ApprovalController < V1::BaseController
  before_action :set_user
  before_action :set_and_check_approver, only: :create

  def index
    @requests = @user.pending_approval_requests
    # @friendships = @user.approval_requests(params[:filter])
  end

  # def friends
  #   @friends = @user.search_accepted_friends(params[:q])
  # end

  def create
    @aproval_request = @user.create_aproval_request_for(@approver)
    if @aproval_request.save
      # Notification.notify_friendship_request_to_user(@user, @friend)
      render :show, status: :created
    else
      render json: @aproval_request.errors, status: :unprocessable_entity
    end
  end

  def update
    @aproval_request = @user.pending_approval_requests.find(params[:id])
    #if @friendship.friend_id == current_user.id #this a policy refactor!
    @aproval_request.accept!
    render :show
  end

  def destroy
    @aproval_request = ApprovalRequest.find(params[:id])
    #if @friendship.friend_id == current_user.id || @friendship.user_id == current_user.id
    @aproval_request.destroy
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