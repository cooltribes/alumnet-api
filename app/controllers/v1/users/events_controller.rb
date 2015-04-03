class V1::Users::EventsController < V1::BaseEventsController


  private

  def set_eventable
    @eventable = User.find(params[:user_id])
  end

end
