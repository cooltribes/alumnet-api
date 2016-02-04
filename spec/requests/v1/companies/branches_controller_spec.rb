require 'rails_helper'

describe V1::Companies::BranchesController, type: :request do
  let!(:user) { User.make! }
  let!(:company) { Company.make! }

  describe "GET /companies/:id/branches" do
    it "return all branches" do
      3.times { Branch.make!(company: company) }
      get company_branches_path(company), {}, basic_header(user.auth_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(3)
    end
  end

  describe "POST /companies/:id/branches" do
    context "with valid attributes" do
      it "should create a Branch" do
        country = Country.make!(:simple)
        city = City.make!(country: country)
        expect {
          post company_branches_path(company), { address: "New address", country_id: country.id, city_id: city.id }, basic_header(user.auth_token)
        }.to change(Branch, :count).by(1)
        expect(response.status).to eq 201
        expect(json["address"]).to eq("New address")
        expect(json["country"]).to eq({ "name" => country.name, "id" => country.id, "cc_iso" => country.cc_iso })
      end
    end
    context "with invalid attributes" do
      it "return the errors in format json" do
        expect {
          post company_branches_path(company), { address: ""  }, basic_header(user.auth_token)
        }.to change(Branch, :count).by(0)
        expect(json).to eq({"address"=>["can't be blank"]})
        expect(response.status).to eq 422
      end
    end
  end

  describe "PUT /companies/:id/branches/:id" do
    it "should update a Branch" do
      branch = Branch.make!(company: company)
      put company_branch_path(company, branch), { address: "Other address" }, basic_header(user.auth_token)
      expect(json["address"]).to eq("Other address")
    end
  end

  describe "DELETE /companies/:id/branches/:id" do
    it "delete a Branch" do
      branch = Branch.make!(company: company)
      expect {
        delete company_branch_path(company, branch), {}, basic_header(user.auth_token)
      }.to change(Branch, :count).by(-1)
      expect(response.status).to eq 204
    end
  end
end