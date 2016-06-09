class V1::BaseCommentsController < V1::BaseController
  include Pundit
  before_action :set_commentable
  before_action :set_comment, except: [:index, :create]

  def index
    @comments = @commentable.comments.with_includes
  end

  def show
  end

  def create
    service = ::Comments::CreateComment.new(@commentable, current_user, comment_params)
    if service.call
      @comment = service.comment
      render :show, status: :created
    else
      render json: service.comment.errors, status: :unprocessable_entity
    end
  end

  def update
    authorize @comment
    service = ::Comments::UpdateComment.new(@commentable, @comment, current_user, comment_params)
    if service.call
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
    params.permit(:comment, :markup_comment, :user_tags_list)
  end
end