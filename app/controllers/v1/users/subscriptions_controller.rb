class V1::Users::SubscriptionsController < V1::BaseController
  before_action :set_user
  before_action :set_user_subscription, only: [:update, :destroy]

  def index
    @user_subscriptions = @user.user_subscriptions
  end

  def create
    @user_subscription = @user.build_subscription(subscription_params, current_user)
    if @user_subscription.save
      render :show, status: :created
    else
      render json: @user_subscription.errors, status: :unprocessable_entity
    end
  end

  def update
    if @user_subscription.update(subscription_params)
      render :show
    else
      render json: @user_subscription.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @user_subscription.destroy
    head :no_content
  end

  private
    def set_user
      @user = User.find(params[:user_id])
    end

    def set_user_subscription
      @user_subscription = @user.user_subscriptions.find(params[:id])
    end

    def subscription_params
      params.permit(:start_date, :end_date, :user_id, :lifetime)
    end
end
