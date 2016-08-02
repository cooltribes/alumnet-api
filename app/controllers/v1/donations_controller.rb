class V1::DonationsController < V1::BaseController
  skip_before_action :authenticate

  def products
    @products = Product.joins(:categories).where(categories: {name: "Donations"})
  end
end