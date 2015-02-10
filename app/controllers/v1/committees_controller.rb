class V1::CommitteesController < V1::BaseController

  def index
    @q = Committee.search(params[:q])
    @committees = @q.result
  end

end