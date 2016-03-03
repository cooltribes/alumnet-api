class V1::Me::EventsController < V1::BaseController
  before_action :set_user

  def managed
    events = @user.managed_events(params[:q])
    @events = Kaminari.paginate_array(events).page(params[:page]).per(params[:per_page])
    render 'v1/events/index'
  end

  private

  def set_user
    @user = current_user
  end
end