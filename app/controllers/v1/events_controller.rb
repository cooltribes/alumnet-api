class V1::EventsController < V1::BaseEventsController
  include Pundit
  skip_before_action :set_eventable

  private

  def set_event
    @event = Event.find(params[:id])
  end

end
