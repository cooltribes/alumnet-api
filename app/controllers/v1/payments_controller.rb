class V1::PaymentsController < V1::BaseController
  before_action :set_payment, except: [:index, :create]
  before_action :set_paymentable, only: [:create]

  def index
    @q = Payment.search(params[:q])
    @payments = @q.result
  end

  def show
  end

  def create
    @payment = Payment.new(payment_params)
    @payment.paymentable = @paymentable
    @payment.save
    render :show, status: :created, location: @payment
  end

  def update
    if @payment.update(payment_params)
      render :show, status: :ok, location: @payment
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

  def set_paymentable
    if params[:paymentable_type]
      @paymentable = params[:paymentable_type].constantize.find(params[:paymentable_id])
    end
  end

  def payment_params
    params.permit(:user_id, :paymentable_id, :paymentable_type, :subtotal, :iva, :total, :reference, :country_id, :city_id, :address)
  end

end