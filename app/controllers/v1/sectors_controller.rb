class V1::SectorsController < V1::BaseController

  def index
    @q = Sector.search(params[:q])
    @sectors = @q.result
  end

end