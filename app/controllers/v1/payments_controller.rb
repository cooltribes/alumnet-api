class V1::PaymentsController < V1::BaseController
  before_action :set_payment, except: [:index, :create, :update]
  before_action :set_paymentable, only: [:create]
  before_action :set_payment_by_reference, only: [:update]

  def index
    @q = Payment.search(params[:q])
    @payments = @q.result
  end

  def show
  end

  def create
    @payment = Payment.new(payment_params)
    @payment.paymentable = @paymentable
    if @payment.save
      if payment_params[:paymentable_type] == 'Event'
        @attendance = Attendance.find_by(event_id: payment_params[:paymentable_id], user_id: payment_params[:user_id])
        @attendance.status = 1
        if @attendance.save
          render :show, status: :created, location: @payment
        else
          render json: @attendance.errors, status: :unprocessable_entity
        end
      end
    else
      render json: @payment.errors, status: :unprocessable_entity
    end
  end

  def update
    if @payment.update(payment_params)
      if @payment.paymentable.update({ status: 2 })
        @payment.user.update({ member: 0 })
        render :show, status: :ok, location: @payment
      else
        render json: @payment.paymentable.errors, status: :unprocessable_entity
      end
    else
      render json: @payment.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @payment.destroy
    head :no_content
  end

  private

  def set_payment
    @payment = Payment.find(params[:id])
  end

  def set_payment_by_reference
    @payment = Payment.find_by(reference: params[:id])
  end

  def set_paymentable
    if params[:paymentable_type]
      @paymentable = params[:paymentable_type].constantize.find(params[:paymentable_id])
    end
  end

  def payment_params
    params.permit(:user_id, :paymentable_id, :paymentable_type, :subtotal, :iva, :total, :reference, :country_id, :city_id, :address, :status)
  end

end