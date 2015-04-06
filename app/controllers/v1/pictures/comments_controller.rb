class V1::Pictures::CommentsController < V1::BaseCommentsController

  private

  def set_commentable
    @commentable = Picture.find(params[:picture_id])
  end

end