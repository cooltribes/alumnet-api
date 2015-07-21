class V1::Users::SubscriptionsController < V1::BaseController
  before_action :set_user
  before_action :set_subscription, only: [:update, :destroy]

  def index
    @subscriptions = @user.subscriptions
  end

  def create
    @subscription = Subscription.new(subscription_params)
    @subscription.creator = current_user
    @subscription.ownership_type = 1
    if @subscription.save
      render :show, status: :created
    else
      render json: @subscription.errors, status: :unprocessable_entity
    end
    # @user_subscription = @user.build_subscription(subscription_params, current_user)
    # if @user_subscription.save
    #   render :show, status: :created
    # else
    #   render json: @user_subscription.errors, status: :unprocessable_entity
    # end
  end

  def update
    if @subscription.update(subscription_params)
      render :show
    else
      render json: @subscription.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @subscription.destroy
    head :no_content
  end

  private
    def set_user
      @user = User.find(params[:user_id])
    end

    def set_user_subscription
      @subscription = @user.subscriptions.find(params[:id])
    end

    def subscription_params
      params.permit(:start_date, :end_date, :user_id, :lifetime)
    end
end
