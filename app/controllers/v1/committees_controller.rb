class V1::CommitteesController < V1::BaseController

  def index
    @q = Committee.ransack(params[:q])
    @committees = @q.result
  end

end