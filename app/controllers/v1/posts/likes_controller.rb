class V1::Posts::LikesController < V1::BaseCommentsController

  private

  def set_likeable
    @likeable = Post.find(params[:post_id])
  end

end