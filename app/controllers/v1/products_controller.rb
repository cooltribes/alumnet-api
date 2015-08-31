class V1::ProductsController < V1::BaseController
  before_action :set_product, except: [:index, :create]

  def index
    @q = Product.search(params[:q])
    @products = @q.result
  end

  def show
  end

  def create
    @product = Product.new(product_params)
    @product.save
    render :show, status: :created,  location: @product
  end

  def update
    if @product.update(product_params)
      render :show, status: :ok, location: @product
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
    head :no_content
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.permit(:sku, :name, :description, :status, :price, :created_at, :updated_at, :product_type, :quantity, :feature)
  end

end