class V1::RegionsController < V1::BaseController
  before_action :set_region, except: [:index]

  def index
    @q = Region.search(params[:q])
    @regions = @q.result
  end

  def show
  end

  private
    def set_region
      @region = Region.find(params[:id])
    end
end