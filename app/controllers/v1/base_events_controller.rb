class V1::BaseEventsController < V1::BaseController
  include Pundit
  before_action :set_eventable
  before_action :set_event, except: [:index, :create]

  def index
    @q = @eventable.events.search(params[:q])
    @events = @q.result
  end

  def contacts
    @contacts = @event.contacts_for(current_user, params[:q])
  end

  def show
  end

  def create
    @event = Event.new(event_params)
    @event.creator = current_user
    @event.cover_uploader = current_user
    if @eventable.events << @event
      @event.create_attendance_for(current_user)
      render :show, status: :created
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end

  def update
    authorize @event
    @event.cover_uploader = current_user
    if @event.update(event_params)
      render :show, status: :ok
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end

  def destroy
    # TODO: PREGUNTAR A YONDRI POR ESTO
    # if @event.event_payments.any?
    #   render json: { message: "the event have orders" }, status: 409
    # else
      @event.destroy
      head :no_content
    # end
  end

  private

  def set_eventable
  end

  def set_event
    if @eventable
      @event = @eventable.events.find(params[:id])
    else
      render json: 'no parent given'
    end
  end

  def event_params
    params.permit(:name, :description, :cover, :event_type, :official, :address,
      :upload_files, :start_date, :start_hour, :end_date, :end_hour, :capacity,
      :city_id, :country_id, :admission_type, :regular_price, :premium_price)
  end

end
