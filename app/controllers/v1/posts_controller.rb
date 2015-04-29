class V1::PostsController < V1::BaseController
  before_action :set_post

  def show
  end

  def like
    like = @post.add_like_by(current_user)
    if like.valid?
      render json: like, status: :ok
    else
      render json: { errors: like.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def unlike
    response = @post.remove_like_of(current_user)
    render json: { ok: response }, status: :ok
  end

  private
    def set_post
      @post = Post.find(params[:id])
    end
end