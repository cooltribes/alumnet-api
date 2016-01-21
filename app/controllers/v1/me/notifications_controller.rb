class V1::Me::NotificationsController < V1::BaseController
  before_action :set_user
  before_action :set_notification, except: [:index, :mark_all_read, :friendship, :general, :mark_requests_all_read]

  def index
    @notifications = @user.general_notifications.order(created_at: :desc).page(params[:page]).per(params[:per_page])
  end

  def friendship
    @notifications = @user.friendship_notifications.order(created_at: :desc).page(params[:page]).per(params[:per_page])
    render :index
  end

  def general
    @notifications = @user.general_notifications.order(created_at: :desc).page(params[:page]).per(params[:per_page])
    render :index
  end

  def mark_as_read
    @notification.mark_as_read(@user)
    head :no_content
  end

  def mark_as_unread
    @notification.mark_as_unread(@user)
    head :no_content
  end

  def mark_all_read
    @user.general_notifications.each do |notification|
      notification.mark_as_read(@user)
    end
    head :no_content
  end

  def mark_requests_all_read
    @user.friendship_notifications.each do |notification|
      notification.mark_as_read(@user)
    end
    head :no_content
  end

  def destroy
    @notification.destroy
    head :no_content
  end

  private
    def set_user
      @user = current_user if current_user
    end

    def set_notification
      @notification = @user.mailbox.notifications.find(params[:id])
    end
end
