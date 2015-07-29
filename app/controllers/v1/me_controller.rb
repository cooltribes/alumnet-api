class V1::MeController < V1::BaseController
  before_action :set_user

  def show
  end

  def activate
    if @user.inactive? && @user.created_by_admin?
      if @user.is_regular? && @user.profile.skills?
        @user.activate!
        render json: { status: 'active' }
      elsif @user.is_external? && @user.profile.contact?
        @user.profile.skills!
        @user.activate!
        render json: { status: 'active' }
      else
        render json: { status: 'fail'}
      end
    else
      render json: { status: 'user is active' }
    end
  end

  def send_invitations
    sender = SenderInvitation.new(params[:contacts], current_user)
    if sender.valid?
      sender.send_invitations
      render json: { status: 'ok', count: sender.count }
    else
      render json: { errors: sender.errors.full_messages }, status: :unprocessable_entity
    end
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

end