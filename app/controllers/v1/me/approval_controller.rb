class V1::Me::ApprovalController < V1::BaseController
  before_action :set_user
  before_action :set_and_check_approver, only: :create

  def index
    @q = @user.get_pending_approval_requests
    @requests = Kaminari.paginate_array(@q).page(params[:page]).per(params[:per_page])
  end

  def approval_requests
    #@requests = @user.approval_requests
    @requests = @user.get_pending_approval_requests(params[:q])
    render :index
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
    countryResidence = @user.profile.residence_country
    superAdmins = User.where(role: "AlumNetAdmin")
    admins = countryResidence.admins | superAdmins

    if countryAiesec
      regionAiesec = countryAiesec.region
      admins = admins | countryAiesec.admins | regionAiesec.admins
    end
    Notification.notify_approval_request_to_admins(admins, @user)
    head :no_content
  end

  def update
    ##TODO: Refactor this
    @approval_request = @user.pending_approval_requests.find(params[:id])
    #if @friendship.friend_id == current_user.id #this a policy refactor!
    @approval_request.accept!
    validate_approval_points()

    requester = @approval_request.user

    if requester.get_approved_requests.count == 3
      requester.activate!
      requester.save_profinda_profile
      requester.subscribe_to_mailchimp_list(@mc, Settings.mailchimp_general_list_id)
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

    def validate_approval_points
      action = Action.find_by(key_name: 'request_approved')
      if action.present? && action.status == "active"
        UserAction.create(value: action.value, generator_id: @approval_request.id, generator_type: action.key_name, user_id: @user.id, action_id: action.id)
        @user.profile.add_points(action.value)
      end
    end
end
