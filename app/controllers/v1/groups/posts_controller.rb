class V1::Groups::PostsController < V1::BaseController
  include Pundit
  before_action :set_group
  before_action :set_post, except: [:index, :create]

  def index
    @q = @group.posts.search(params[:q])
    @posts = @q.result
  end

  def show
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user
    if @group.posts << @post
      render :show, status: :created,  location: [@group, @post]
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  def update
    authorize @post
    if @post.update(post_params)
      render :show, status: :ok,  location: [@group, @post]
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

  def set_group
    @group = Group.find(params[:group_id])
  end

  def set_post
    if @group
      @post = @group.posts.find(params[:id])
    else
      render json: 'TODO get this error'
    end
  end

  def post_params
    params.permit(:body)
  end

end
