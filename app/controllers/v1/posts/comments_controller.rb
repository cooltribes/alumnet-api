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

  def like
    like = @comment.add_like_by(current_user)
    if like.valid?
      render json: like, status: :ok
    else
      render json: { errors: like.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def unlike
    response = @comment.remove_like_of(current_user)
    render json: { ok: response}, status: :ok
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