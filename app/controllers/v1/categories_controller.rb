class V1::CategoriesController < V1::BaseController
  before_action :set_category, except: [:index, :create]

  def index
    @q = Category.ransack(params[:q])
    @categories = @q.result
  end

  def show
  end

  def create
    @category = Category.new(category_params)
    @category.save
    render :show, status: :created,  location: @category
  end

  def update
    if @category.update(category_params)
      render :show, status: :ok, location: @category
    else
      render json: @category.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @category.destroy
    head :no_content
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.permit(:name, :description, :status, :father_id, :created_at, :updated_at)
  end

end