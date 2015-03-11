class V1::AttendancesController < V1::BaseController
  include Pundit
  before_action :set_attendance, except: [:index, :create]

  def index
    @q = Attendance.search(params[:q])
    @attendances = @q.result
  end


  def create
    @attendance = Attendance.new(create_params)
    if @attendance.save
      # Notificar al usuario
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

    def create_params
      params.permit(:user_id, :event_id)
    end

    def update_params
      params.permit(:status)
    end
end
