class V1::Groups::EventsController < V1::BaseController
  before_action :set_group
  before_action :set_event, except: [:index, :create]

  def index
    @q = @group.events.search(params[:q])
    @events = @q.result
  end

  def show
  end

  def create
    @event = Event.new(event_params)
    @event.user = current_user
    if @group.events << @event
      render :show, status: :created
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end

  def update
    if @event.update(event_params)
      render :show, status: :ok
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @event.destroy
    head :no_content
  end

  private

  def set_group
    @group = Group.find(params[:group_id])
  end

  def set_event
    if @group
      @event = @group.events.find(params[:id])
    else
      render json: 'TODO get this error'
    end
  end

  def event_params
    params.permit(:name, :description, :cover, :event_type, :official, :address,
      :date_init, :hour_init, :date_end, :hour_end, :capacity, :city_id, :country_id)
  end

end
