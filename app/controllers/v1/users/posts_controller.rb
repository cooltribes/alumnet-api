class V1::Users::PostsController < V1::BaseController
  include Pundit
  before_action :set_user
  before_action :set_post, except: [:index, :create]

  def index
    @q = @user.posts.search(params[:q])
    @posts = @q.result
  end

  def show
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user #set the author
    if @user.posts << @post
      render :show, status: :created,  location: [@user, @post]
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  def update
    authorize @post
    if @post.update(post_params)
      render :show, status: :ok,  location: [@user, @post]
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
    @user = User.find(params[:user_id])
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
