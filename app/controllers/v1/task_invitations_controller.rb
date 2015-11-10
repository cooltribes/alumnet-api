class V1::TaskInvitationsController < V1::BaseController
  before_action :set_invitation, except: [:index, :create]

  def index
    @q = current_user.task_invitations.not_accepted.ransack(params[:q])
    @task_invitations = @q.result
  end

  def create
    @task_invitation = TaskInvitation.new(invitation_params)
    if @task_invitation.save
      render :show, status: :created
    else
      render json: @task_invitation.errors, status: :unprocessable_entity
    end
  end

  def update
    @task_invitation.accept!
    render :show, status: :ok
  end

  def destroy
    @task_invitation.destroy
    head :no_content
  end

  private
    def set_invitation
      @task_invitation = current_user.task_invitations.find(params[:id])
    end

    def invitation_params
      params.permit(:user_id, :task_id)
    end

end