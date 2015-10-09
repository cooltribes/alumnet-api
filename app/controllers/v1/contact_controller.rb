class V1::ContactController < V1::BaseController
  before_action :set_user
  
  def create
    UserMailer.send_message_to_admin(params[:email], @user, params[:message]).deliver_now
    render json: { message: params[:message] }, status: :ok
  end

  private
    def set_user
      @user = User.find(params[:user_id])
    end
end