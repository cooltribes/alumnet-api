class V1::Posts::LikesController < V1::BaseLikesController

  private

  def set_likeable
    @likeable = Post.find(params[:post_id])
  end

end