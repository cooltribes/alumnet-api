class V1::MeController < V1::BaseController
  before_action :set_user

  def show
  end

  def send_invitations
    Notification.send_invitations_to_alumnet(invitation_params, current_user)
    render json: { status: 'ok' }
  end

  def messages
    @receipts = @user.receipts.messages_receipts.limit(3)
    render "v1/me/receipts/index", status: :ok
  end

  def update
    if @user.update(user_params)
      render :show, status: :ok,  location: me_path
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  private
    def user_params
      params.permit(:email, :password, :password_confirmation)
    end

    def set_user
      @user = current_user if current_user
    end

    def invitation_params
      if params[:contacts].is_a?(Hash)
        params[:contacts].values
      elsif params[:contacts].is_a?(Array)
        params[:contacts]
      end
    end
end