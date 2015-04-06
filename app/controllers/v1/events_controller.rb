class V1::EventsController < V1::BaseEventsController
  skip_before_action :set_eventable

  def index
    @q = Event.open.search(params[:q])
    @events = @q.result
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

end
