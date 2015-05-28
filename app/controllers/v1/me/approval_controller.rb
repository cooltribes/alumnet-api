class V1::Me::ApprovalController < V1::BaseController
  before_action :set_user
  before_action :set_and_check_approver, only: :create

  def index
    @requests = @user.get_pending_approval_requests
  end


  def create
    @approval_request = @user.create_approval_request_for(@approver)
    if @approval_request.save
      Notification.notify_approval_request_to_user(@user, @approver)
      render :show, status: :created
    else
      render json: @approval_request.errors, status: :unprocessable_entity
    end
  end

  def notify_admins
    countryAiesec = @user.profile.experiences.where(exp_type: 0).first.committee.country
    regionAiesec = countryAiesec.region
    countryResidence = @user.profile.residence_country
    superAdmins = User.where(role: "AlumNetAdmin")
    admins = countryAiesec.admins | regionAiesec.admins | countryResidence.admins | superAdmins
    # byebug
    Notification.notify_approval_request_to_admins(admins, @user)
    head :no_content
  end

  def update
    ##TODO: Refactor this
    @approval_request = @user.pending_approval_requests.find(params[:id])
    #if @friendship.friend_id == current_user.id #this a policy refactor!
    @approval_request.accept!

    requester = @approval_request.user

    if requester.get_approved_requests.count == 3
      requester.activate!
      requester.save_profinda_profile
      @mc.lists.subscribe(Settings.mailchimp_general_list_id, {'email' => requester.email}, nil, 'html', false, true, true, true)
    end

    #Create a friendship between users
    friendship = requester.create_friendship_for(@user)

    if friendship.save
      friendship.accept!(false)
      #Notificate for a new friendship created but not accepted
      Notification.notify_new_friendship_by_approval(requester, @user)
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
