class V1::BannersController < V1::BaseController
  include Pundit
  before_action :set_banner, except: [:index, :create]

  def index
    @q = Banner.search(params[:q])
    @banners = @q.result
  end


  def show
  end

  def create
    @banner = Banner.new(banner_params)
    if @banner.save
      render :show, status: :created,  location: @banner
    else
      render json: @banner.errors, status: :unprocessable_entity
    end
  end

 
  def update
    #authorize @banner    
    if @banner.update(banner_params)
      render :show, status: :ok,  location: @banner
    else
      render json: @banner.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @banner.destroy
    head :no_content
  end

  private

  def set_banner
    @banner = Banner.find(params[:id])
  end

  def banner_params
    params.permit(:title,:link,:description,:picture,:timelapse)
  end


end
