class V1::Users::PostsController < V1::BasePostsController

  private

  def set_postable
    @postable = User.find(params[:user_id])
  end

end
