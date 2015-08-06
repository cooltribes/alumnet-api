class V1::ProductServicesController < V1::BaseController

  def index
    @q = ProductService.search(params[:q])
    @product_services = @q.result
    render 'v1/companies/product_services/index'
  end

end
