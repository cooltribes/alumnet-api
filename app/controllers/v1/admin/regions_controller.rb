class V1::Admin::RegionsController < V1::AdminController
  before_action :set_region, except: [:index, :create]

  def index
    @q = Region.search(params[:q])
    @regions = @q.result
  end

  def show
  end

  def create
    @region = Region.new(region_params)
    if @region.save
      render :show, status: :created
    else
      render json: @region.errors, status: :unprocessable_entity
    end
  end

  def update
    if @region.update(region_params)
      render :show, status: :ok
    else
      render json: @region.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @region.destroy
    head :no_content
  end

  private
    def set_region
      @region = Region.find(params[:id])
    end

    def region_params
      params.permit(:name, country_ids:[])
    end
end