require 'rails_helper'

describe V1::ProductServicesController, type: :request do
  let!(:user) { User.make! }

  describe "GET /product_services" do
    it "return all product_services" do
      3.times { ProductService.make!(:service) }
      get product_services_path, {}, basic_header(user.auth_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(3)
    end
  end
end