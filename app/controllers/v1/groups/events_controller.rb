class V1::Groups::EventsController < V1::BaseEventsController

  private

  def set_eventable
    @eventable = Group.find(params[:group_id])
  end

end
