class V1::Users::PaymentsController < V1::BaseController
  before_action :set_payment, except: [:index, :create]
  before_action :set_user

  def index
    @payments = @user.payments
  end


  def create
    @payment = UserProduct.new(create_params)
    if @payment.save
      render :show, status: :created
    else
      render json: @payment.errors, status: :unprocessable_entity
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

    def set_payment
      @payment = Payment.find(params[:id])
    end

    def create_params
      params.permit(:user_id, :product_id, :status, :start_date, :end_date, :quantity, :transaction_type, :created_at, :updated_at)
    end

    def update_params
      params.permit(:status, :start_date, :end_date, :quantity, :transaction_type)
    end
end
