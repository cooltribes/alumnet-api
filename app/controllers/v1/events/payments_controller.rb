class V1::Events::PaymentsController < V1::BaseController
  before_action :set_event

  def create
    @event_payment = EventPayment.new(payment_params)
    if @event_payment.save
      @attendance = Attendance.find(payment_params[:attendance_id])
      @attendance.status = 1
      @attendance.save
      render json: { status: :created }
    else
      render json: @event_payment.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @event_payment.destroy
    head :no_content
  end

  private
    def set_event
      @event = Event.find(params[:event_id])
    end

    def payment_params
      params.permit(:price, :reference, :user_id, :event_id, :attendance_id)
    end
end