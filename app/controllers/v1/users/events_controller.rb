class V1::Users::EventsController < V1::BaseController
  before_action :set_user
  before_action :set_event, except: [:index, :create]

  def index
    @q = @user.invited_events.search(params[:q])
    @events = @q.result
  end

  def contacts
    @contacts = @event.contacts_for(current_user, params[:q])
  end

  def show
  end

  def create
    @event = Event.new(event_params)
    @event.creator = current_user
    if @user.events << @event
      @event.create_attendance_for(current_user)
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

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_event
    if @user
      @event = @user.events.find(params[:id])
    else
      render json: 'TODO get this error'
    end
  end

  def event_params
    params.permit(:name, :description, :cover, :event_type, :official, :address,
      :start_date, :start_hour, :end_date, :end_hour, :capacity, :city_id, :country_id)
  end

end