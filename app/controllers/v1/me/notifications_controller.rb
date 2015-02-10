class V1::Me::NotificationsController < V1::BaseController
  before_action :set_user

  def index
    @notifications = @user.mailbox.notifications
  end

  def destroy
    @notification = @user.mailbox.notifications.find(params[:id])
    @notification.destroy
    head :no_content
  end

  private
    def set_user
      @user = current_user if current_user
    end
end
