class V1::AttendancesController < V1::BaseController
  include Pundit
  before_action :set_attendance, except: [:index, :create]
  before_action :set_event, only: :index

  def index
    @q = if @event
      @event.attendances.search(params[:q])
    else
      Attendance.search(params[:q])
    end
    @attendances = @q.result
  end


  def create
    ## TODO: Add column to store the creator of attendance.
    @attendance = Attendance.new(create_params)
    if @attendance.save
      Notification.notify_invitation_event_to_user(@attendance, @current_user)
      render :show, status: :created
    else
      render json: @attendance.errors, status: :unprocessable_entity
    end
  end

  def update
    authorize @attendance
    if @attendance.update(update_params)
      render :show
    else
      render json: @attendance.errors, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @attendance
    @attendance.destroy
    head :no_content
  end

  private

    def set_attendance
      @attendance = Attendance.find(params[:id])
    end

    def set_event
      if params[:event_id]
        @event = Event.find(params[:event_id])
      end
    end

    def create_params
      params.permit(:user_id, :event_id, :status)
    end

    def update_params
      params.permit(:status)
    end
end
