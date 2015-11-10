class V1::SectorsController < V1::BaseController

  def index
    @q = Sector.ransack(params[:q])
    @sectors = @q.result
  end

end