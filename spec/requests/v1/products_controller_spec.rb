require 'rails_helper'

describe V1::ProductsController, type: :request do
  let!(:user) { User.make! }

  def valid_attributes
    { name: "Product 1", description: "product description", price: 50 }
  end

  describe "GET products" do
    it "return all products " do
      3.times { Product.make! }
      get products_path,{}, basic_header(user.auth_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(3)
    end
  end

  describe "POST products" do
    it "should create a product" do
      product = Product.make!
      expect {
        post products_path(product), valid_attributes, basic_header(user.auth_token)
      }.to change(Product, :count).by(1)
      expect(response.status).to eq 201
    end
  end
end