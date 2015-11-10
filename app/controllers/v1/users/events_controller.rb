class V1::Users::EventsController < V1::BaseEventsController

  def index
    @q = @eventable.invited_events.ransack(params[:q])
    @events = @q.result
  end

  private

  def set_eventable
    @eventable = User.find(params[:user_id])
  end

end
