class V1::Me::PostsController < V1::BaseController
  include Pundit

  before_action :set_user
  before_action :set_post, except: [:index, :create]

  def index
    q = @user.all_posts(params[:q])
    @posts = Kaminari.paginate_array(q).page(params[:page]).per(params[:per_page])

    render 'v1/users/posts/index'
  end

  def show
    render 'v1/users/posts/show', status: :ok
  end

  def create
    @post = Post.new(post_params)
    @post.user = @user
    if @user.posts << @post
      render 'v1/users/posts/show', status: :created,  location: [@user, @post]
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  def update
    authorize @post
    if @post.update(post_params)
      render 'v1/users/posts/show', status: :ok,  location: [@user, @post]
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

  def set_user
    @user = current_user
  end

  def set_post
    if @user
      @post = @user.posts.find(params[:id])
    else
      render json: 'TODO get this error'
    end
  end

  def post_params
    params.permit(:body, picture_ids:[])
  end

end
