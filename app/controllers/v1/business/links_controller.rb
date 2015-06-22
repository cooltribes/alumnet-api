class V1::Business::LinksController < V1::BaseController
  before_action :set_business
  before_action :set_link, except: [:index, :create]

  def index
    @q = @business.links.search(params[:q])
    @links = @q.result
  end

  def create
    @link = Link.new(link_params)
    if @business.links << @link
      render :show, status: :created
    else
      render json: @link.errors, status: :unprocessable_entity
    end
  end

  def update
    if @link.update(link_params)
      render :show, status: :ok
    else
      render json: @link.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @link.destroy
    head :no_content
  end

  private

  def set_business
    @business = CompanyRelation.find(params[:business_id])
  end

  def set_link
    if @business
      @link = @business.links.find(params[:id])
    else
      render json: 'no business given'
    end
  end

  def link_params
    params.permit(:title, :description, :url)
  end
end
