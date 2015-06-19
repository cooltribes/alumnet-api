class V1::Users::PrizesController < V1::BaseController
  before_action :set_user_prize, except: [:index, :create]
  before_action :set_prize
  before_action :set_user

  def index
    @user_prizes = @user.user_prizes
  end


  def create
    if validate_avilable_points()
      @user_prize = UserPrize.new(create_params)
      if @user_prize.save
        @user_subscription = save_subscription()
        if @user_subscription
          @user.profile.substract_points(@user_prize.price)
          render :show, status: :created
        else
          render json: @user_subscription.errors, status: :unprocessable_entity
        end
      else
        render json: @user_prize.errors, status: :unprocessable_entity
      end
    else
      render json: {'error': 'user does not have enough points' }, status: :unprocessable_entity
    end
  end

  # def update
  #   authorize @attendance
  #   if @attendance.update(update_params)
  #     render :show
  #   else
  #     render json: @attendance.errors, status: :unprocessable_entity
  #   end
  # end

  # def destroy
  #   authorize @attendance
  #   @attendance.destroy
  #   head :no_content
  # end

  private
    def set_user
      @user = User.find(params[:user_id])
    end

    def set_user_prize
      @user_prize = UserPrize.find(params[:id])
    end

    def set_prize
      if params[:prize_id]
        @prize = Prize.find(params[:prize_id])
      end
    end

    def create_params
      params.permit(:user_id, :prize_id, :status, :price, :created_at, :updated_at, :prize_type, :remaining_quantity)
    end

    def update_params
      params.permit(:status)
    end

    def save_subscription
      subscription_params = { start_date: Time.zone.now, end_date: Time.zone.now + @user_prize.remaining_quantity.months, user: @user, lifetime: false }
      @user_subscription = @user.build_subscription(subscription_params, current_user)
      @user_subscription.save
    end

    def validate_avilable_points
      return false unless @user.profile.points >= @prize.price
      return true
    end
end
