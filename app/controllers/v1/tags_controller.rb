class V1::TagsController < V1::BaseController

  def index
    @q = ActsAsTaggableOn::Tag.ransack(params[:q])
    @tags = @q.result
    render json: @tags
  end

end

