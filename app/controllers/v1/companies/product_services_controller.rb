class V1::Companies::ProductServicesController < V1::BaseController
  before_action :set_company
  before_action :set_product_service, except: [:index, :create]

  def index
    @q = @company.product_services.search(params[:q])
    @product_services = @q.result
  end

  def create
    @product_service = ProductService.find_or_initialize_by(product_service_params)
    if @product_service.save
      @company.product_services << @product_service
      render :show, status: :created,  location: [@company, @product_service]
    else
      render json: @product_service.errors, status: :unprocessable_entity
    end
  end

  def update
    if @product_service.update(product_service_params)
      render :show, status: :ok,  location: [@company, @product_service]
    else
      render json: @product_service.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @company.product_services.destroy(@product_service)
    head :no_content
  end

  private

  def set_company
    @company = Company.find(params[:company_id])
  end

  def set_product_service
    if @company
      @product_service = @company.product_services.find(params[:id])
    else
      render json: 'Company not given'
    end
  end

  def product_service_params
    params.permit(:name, :service_type)
  end
end