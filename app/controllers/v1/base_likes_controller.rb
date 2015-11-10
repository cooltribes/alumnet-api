class V1::BaseLikesController < V1::BaseController
  # include Pundit
  before_action :set_likeable

  def index
    @q = @likeable.likes.without_user(current_user).ransack(params[:q])
    @likes = @q.result
  end

  private

  def set_likeable
  end
end
