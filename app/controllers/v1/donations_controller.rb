class V1::DonationsController < V1::BaseController
  skip_before_action :authenticate

  def products
    @products = Product.joins(:categories).where(categories: {name: "Donations"})
  end

  def get_product
  	@product = Product.find(params[:id])
  	unless @product.present?
      render json: { error: "Product not found" }, status: 404
    end
  end
end