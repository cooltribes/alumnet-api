class V1::Users::SubscriptionsController < V1::BaseController
  before_action :set_user
  before_action :set_user_subscription, only: [:update, :destroy]
  #before_action :set_and_check_subscription, only: :create

  def index
    @user_subscriptions = @user.user_subscriptions
  end

  def create
    #render json: @user_subscription.errors, status: :unprocessable_entity
    @user_subscription = @user.build_subscription(params, current_user)
    if @user_subscription.save
      @user.member = 1
      @user.save
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

    def set_subscription
      @user_subscription = @user.user_subscriptions.find(params[:id])
    end

    def set_and_check_subscription
      #unless @subscription = Subscription.find_by(id: params[:subscription_id])
        #render json: { error: "Subscription not found" }
      #end
      if(params[:subscription_id] == "true")
        @subscription = Subscription.find_by(id: 2);
      else
        @subscription = Subscription.find_by(id: 1);
      end
    end

    def subscription_params
      params.permit(:approved) ##TODO select the attributes for update
    end
end