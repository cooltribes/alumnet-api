class V1::Me::PostsController < V1::BaseController
  before_action :set_user
  before_action :set_post, except: [:index, :create]

  def index
    @q = @user.groups_posts.search(params[:q])
    @posts = @q.result
    render 'v1/users/posts/index'
  end

  def show
    render 'v1/users/posts/show', status: :ok
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user #set the author
    if @user.posts << @post
      render 'v1/users/posts/show', status: :created,  location: [@user, @post]
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  def update
    if @post.update(post_params)
      render 'v1/users/posts/show', status: :ok,  location: [@user, @post]
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  def destroy
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
    params.permit(:body)
  end

end
