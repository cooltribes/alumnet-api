require 'rails_helper'

describe V1::Users::ProductsController, type: :request do
  let!(:user) { User.make! }

  describe "GET user products" do
    it "return all user products " do
      3.times { UserProduct.make!(user: user) }
      get user_products_path(user),{}, basic_header(user.auth_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(3)
    end
  end

  describe "POST user products" do
    it "should create an user product" do
      product = Product.make!
      user = User.make!
      valid_attributes = { product_id: product.id, status: 1, transaction_type: 1 }
      expect {
        post user_products_path(user), valid_attributes , basic_header(user.auth_token)
      }.to change(UserProduct, :count).by(1)
    end
  end
end