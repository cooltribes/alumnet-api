class V1::EventsController < V1::BaseController
  include Pundit
  before_action :set_event

  def show
  end

  def update
    authorize @event
    if @event.update(event_params)
      render :show, status: :ok
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.permit(:name, :description, :cover, :event_type, :official, :address,
      :start_date, :start_hour, :end_date, :end_hour, :capacity, :city_id, :country_id)
  end
end
