class V1::Events::PostsController < V1::BaseController
  include Pundit
  before_action :set_event
  before_action :set_post, except: [:index, :create]

  def index
    @q = @event.posts.search(params[:q])
    @posts = @q.result
  end

  def show
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user
    if @event.posts << @post
      render :show, status: :created,  location: [@event, @post]
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  def update
    authorize @post
    if @post.update(post_params)
      render :show, status: :ok,  location: [@event, @post]
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @post
    @post.destroy
    head :no_content
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def set_post
    if @event
      @post = @event.posts.find(params[:id])
    else
      render json: 'TODO get this error'
    end
  end

  def post_params
    params.permit(:body, picture_ids:[])
  end

end
