class V1::EventsController < V1::BaseEventsController
  skip_before_action :set_eventable

  def index
    @q = Event.open.search(params[:q])
    @events = @q.result
  end

  def cropping
    @event.assign_attributes(crop_params)
    @event.crop
    render json: { status: 'success', url: @event.cover.crop.url }
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def crop_params
    params.permit(:imgW, :imgH, :imgX1, :imgY1, :cropW, :cropH)
  end

end
