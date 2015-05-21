class V1::Events::PaymentsController < V1::BaseController
  before_action :set_user

  def create
    @event_payment = @event.build_payment(payment_params, current_user)
    if @event_payment.save
      render :text => 'Created'
    else
      render json: @event_payment.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @event_payment.destroy
    head :no_content
  end

  private
    def set_user
      @user = User.find(params[:user_id])
    end

    def payment_params
      params.permit(:start_date, :end_date, :user_id, :lifetime)
    end
end