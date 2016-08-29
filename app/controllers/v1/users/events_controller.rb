class V1::Users::EventsController < V1::BaseEventsController

  def index
    q = @eventable.invited_events.ransack(params[:q])
    @events = q.result.page(params[:page]).per(params[:per_page]).order(start_date: :desc)
    if browser.platform.ios? || browser.platform.android? || browser.platform.other?
      render 'mobile/events'
    end
  end

  private

  def set_eventable
    @eventable = User.find(params[:user_id])
  end

end
