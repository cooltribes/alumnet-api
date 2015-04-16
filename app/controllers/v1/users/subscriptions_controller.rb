class V1::Users::SubscriptionsController < V1::BaseController
  before_action :set_user
  before_action :set_user_subscription, only: [:update, :destroy]

  def index
    @user_subscriptions = @user.user_subscriptions
  end

  def create
    #render json: @user_subscription.errors, status: :unprocessable_entity
    @user_subscription = @user.build_subscription(subscription_params, current_user)
    #render json: @user_subscription
    if @user_subscription.save
<<<<<<< HEAD
      # if(params[:lifetime] == "true")
      #   @user.member = 3
      # else
      #   if((params[:end].to_date-params[:begin].to_date).to_i<30) 
      #     @user.member = 2
      #   else
      #     @user.member = 1
      #   end
      # end
      # @user.save
=======
      if(params[:lifetime] == "true")
        @user.member = 3
      else
        if((params[:end].to_date-params[:begin].to_date).to_i<30)
          @user.member = 2
        else
          @user.member = 1
        end
      end
      @user.save
>>>>>>> 4e3163a021b371685a20509db61e8d17b7ae8918
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
