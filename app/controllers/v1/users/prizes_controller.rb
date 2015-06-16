class V1::Users::PrizesController < V1::BaseController
  before_action :set_user_prize, except: [:index, :create]
  before_action :set_prize, only: :index
  before_action :set_user

  def index
    @user_prizes = @user.user_prizes
  end


  def create
    @user_prize = UserPrize.new(create_params)
    if @user_prize.save
      render :show, status: :created
    else
      render json: @user_prize.errors, status: :unprocessable_entity
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
end
