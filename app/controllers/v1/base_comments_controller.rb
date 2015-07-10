class V1::BaseCommentsController < V1::BaseController
  include Pundit
  before_action :set_commentable
  before_action :set_comment, except: [:index, :create]

  def index
    @comments = @commentable.comments
  end

  def show
  end

  def create
    @comment = Comment.new(comment_params)
    @comment.user = current_user
    if @commentable.comments << @comment
      render :show, status: :created,  location: [@commentable, @comment]
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  def update
    authorize @comment
    if @comment.update(comment_params)
      render :show, status: :ok,  location: [@commentable, @comment]
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @comment
    @comment.really_destroy!
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

  def set_commentable
  end

  def set_comment
    if @commentable
      @comment = @commentable.comments.find(params[:id])
    else
      render json: 'no parent given'
    end
  end

  def comment_params
    params.permit(:comment)
  end
end