class V1::EventsController < V1::BaseEventsController
  skip_before_action :set_eventable

  def index
    @q = Event.open.ransack(params[:q])
    @events = @q.result.order(start_date: :desc)
    if @events.class == Array
      @events = Kaminari.paginate_array(@events).page(params[:page]).per(params[:per_page])
    else
      @events = @events.page(params[:page]).per(params[:per_page]) # if @posts is AR::Relation object
    end
  end

  def search
    my_events = current_user.events.map(&:id)    
    query = { query: {
        filtered: {
            query: params[:q][:query],
            filter: {
                not: {
                  terms: {
                    "id" => my_events
                  }
                }
            }
        }
      } 
    }     
    @results = Event.search(query).page(params[:page]).per(params[:per_page])    
    event_ids = @results.results.to_a.map(&:id)
    @events = Event.where(id: event_ids).order(start_date: :desc)
    if browser.platform.ios? || browser.platform.android? || browser.platform.other?
      render 'mobile/events'
    else
      render :index, status: :ok
    end
  end

  def cropping
    @event.assign_attributes(crop_params)
    @event.crop('cover')
    render json: { status: 'success', url: @event.cover.crop.url }
  end

  def picture
    render json: { error: "Not file given" }, status: :unprocessable_entity unless params.key?(:file)
    service = ::Pictures::CreatePicture.new(@event, current_user, params)
    if service.call
      @picture = service.picture
      render 'v1/pictures/show', status: :created
    else
      render json: service.errors, status: :unprocessable_entity
    end
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def crop_params
    params.permit(:imgInitH, :imgInitW, :imgW, :imgH, :imgX1, :imgY1, :cropW, :cropH)
  end

end
