class V1::Users::EventsController < V1::BaseEventsController

  def index
    q = @eventable.invited_events.ransack(params[:q])
    @events = q.result.page(params[:page]).per(params[:per_page]).order(start_date: :desc)
  end

  private

  def set_eventable
    @eventable = User.find(params[:user_id])
  end

end
