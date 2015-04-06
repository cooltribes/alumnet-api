class V1::Events::PostsController < V1::BasePostsController

  private

  def set_postable
    @postable = Event.find(params[:event_id])
  end

end
