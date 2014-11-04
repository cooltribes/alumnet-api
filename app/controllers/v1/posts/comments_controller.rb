class V1::Posts::CommentsController < V1::BaseController
  before_action :set_post
  before_action :set_comment, except: [:index, :create]

  def index
    @comments = @post.comments
  end

  def show
  end

  def create
    @comment = Comment.new(comment_params)
    @comment.user = current_user
    if @post.comments << @comment
      render :show, status: :created,  location: [@post, @comment]
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  def update
    if @comment.update(comment_params)
      render :show, status: :ok,  location: [@post, @comment]
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy
    head :no_content
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def set_comment
    if @post
      @comment = @post.comments.find(params[:id])
    else
      render json: 'TODO get this error'
    end
  end

  def comment_params
    params.permit(:comment)
  end
end