class V1::Groups::PostsController < V1::BasePostsController

  private

  def set_postable
    @postable = Group.find(params[:group_id])
  end

end
