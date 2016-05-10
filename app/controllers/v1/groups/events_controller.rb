class V1::Groups::EventsController < V1::BaseEventsController

  private

  def set_eventable
    @eventable = Group.find(params[:group_id])
  end


  def event_params
    params.permit(:name, :description, :cover, :event_type, :official, :address,
      :start_date, :start_hour, :end_date, :end_hour, :capacity, :city_id, :country_id,
      :invite_group_members, :admission_type, :regular_price, :premium_price, :short_description)
  end

end
