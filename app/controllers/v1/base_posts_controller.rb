class V1::BasePostsController < V1::BaseController
  include Pundit
  before_action :set_postable
  before_action :set_post, except: [:index, :create]

  def index
    @q = @postable.posts.search(params[:q])
    @posts = @q.result
    #@posts = @q.page(params[:page]).per(params[:per_page])
    @posts = Kaminari.paginate_array(@posts).page(params[:page]).per(params[:per_page]) 
    #if @posts.class == Array
    #  @posts = Kaminari.paginate_array(@posts).page(params[:page]).per(params[:per_page]) 
    #else
    #  @posts = @posts.page(params[:page]).per(params[:per_page]) # if @posts is AR::Relation object 
    #end
  end

  def show
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user
    if @postable.posts << @post
      render :show, status: :created,  location: [@postable, @post]
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  def update
    authorize @post
    if @post.update(post_params)
      render :show, status: :ok,  location: [@postable, @post]
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @post
    @post.really_destroy!
    head :no_content
  end

  private

  def set_postable
  end

  def set_post
    if @postable
      @post = @postable.posts.find(params[:id])
    else
      render json: 'no parent given'
    end
  end

  def post_params
    params.permit(:body, picture_ids:[])
  end
end
