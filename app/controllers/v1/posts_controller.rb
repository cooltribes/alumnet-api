class V1::PostsController < V1::BaseController

  def show
    @post = Post.find(params[:id])
  end
end