require 'rails_helper'

describe V1::Companies::ProductServicesController, type: :request do
  let!(:user) { User.make! }
  let!(:company) { Company.make! }

  describe "GET /companies/:id/product_services" do
    it "return all product_services" do
      3.times do
        company.product_services << ProductService.make!(:service)
      end
      get company_product_services_path(company), {}, basic_header(user.auth_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(3)
    end
  end

  describe "POST /companies/:id/product_services" do
    context "with valid attributes" do
      it "should create a product in company" do
        expect {
          post company_product_services_path(company), { name: "New name", service_type: 1 }, basic_header(user.auth_token)
        }.to change(ProductService, :count).by(1)
        expect(response.status).to eq 201
        expect(json["name"]).to eq("New name")
        expect(json["service_type"]).to eq(1)
      end
    end
    context "with invalid attributes" do
      it "return the errors in format json" do
        expect {
          post company_product_services_path(company), { name: "" }, basic_header(user.auth_token)
        }.to change(ProductService, :count).by(0)
        expect(json).to eq({"name"=>["can't be blank"]})
        expect(response.status).to eq 422
      end
    end
  end

  describe "PUT /companies/:id/product_services/:id" do
    it "should update a product" do
      product = ProductService.make!(:product)
      company.product_services << product
      put company_product_service_path(company, product), { name: "Other name" }, basic_header(user.auth_token)
      expect(json["name"]).to eq("Other name")
    end
  end

  describe "DELETE /companies/:id/product_services/:id" do
    it "delete a ProductService" do
      product = ProductService.make!(:product)
      company.product_services << product
      expect {
        delete company_product_service_path(company, product), {}, basic_header(user.auth_token)
      }.to change(ProductService, :count).by(-1)
      expect(response.status).to eq 204
    end
  end
end