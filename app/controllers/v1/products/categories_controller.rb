class V1::Products::CategoriesController < V1::BaseController
  before_action :set_product_category, except: [:index, :create]
  before_action :set_product
  before_action :set_category

  def index
    @q = ProductCategory.ransack(params[:q])
    @product_categories = @q.result
  end

  # def show
  # end

  def create
    @product_category = ProductCategory.new(product_category_params)
    @product_category.save
    head :ok, content_type: "text/html"
    #render :show, status: :created, location: @product_category
  end

  def destroy
    @product_category.destroy
    head :no_content
  end

  private

  def set_product_category
    @product_category = ProductCategory.find(params[:id])
  end

  def set_product
    @product = Product.find(params[:product_id])
  end

  def set_category
    if params[:category_id]
      @category = Category.find(params[:category_id])
    end
  end

  def product_category_params
    params.permit(:id, :product_id, :category_id, :created_at, :updated_at)
  end

end