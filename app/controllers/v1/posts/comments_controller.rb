class V1::Posts::CommentsController < V1::BaseCommentsController

  private

  def set_commentable
    @commentable = Post.find(params[:post_id])
  end

end