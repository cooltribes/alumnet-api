require 'rails_helper'

describe V1::CompaniesController, type: :request do
  let!(:user) { User.make! }

  describe "GET /companies" do
    it "return all companies" do
      3.times { Company.make! }
      get companies_path, {}, basic_header(user.auth_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(3)
    end
  end

  describe "GET /companies/:id/employees" do
    it "return all employees of company" do
      company = Company.make!
      3.times do
        user = User.make!
        Experience.make!(:profesional, company: company, profile: user.profile, current: true)
      end
      get employees_company_path(company), {}, basic_header(user.auth_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(3)
    end
  end

  describe "GET /companies/:id/past_employees" do
    it "return all past employees of company" do
      company = Company.make!
      2.times do
        user = User.make!
        Experience.make!(:profesional, company: company, profile: user.profile)
      end
      get past_employees_company_path(company), {}, basic_header(user.auth_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(2)
    end
  end

  describe "POST /companies" do
    context "with valid attributes" do
      it "should create a company" do
        expect {
          post companies_path, { name: "New Company" }, basic_header(user.auth_token)
        }.to change(Company, :count).by(1)
        expect(response.status).to eq 201
      end
    end
    context "with invalid attributes" do
      it "return the errors in format json" do
        expect {
          post companies_path, { name: ""  }, basic_header(user.auth_token)
        }.to change(Company, :count).by(0)
        expect(json).to eq({"name"=>["can't be blank"]})
        expect(response.status).to eq 422
      end
    end
  end

  describe "PUT /companies/:id" do
    it "should update a company" do
      company = Company.make!
      put company_path(company), { name: "New Name" }, basic_header(user.auth_token)
      expect(json["name"]).to eq("New Name")
    end
  end

  describe "DELETE /companies/:id" do
    it "delete a company" do
      company = Company.make!
      expect {
        delete company_path(company), {}, basic_header(user.auth_token)
      }.to change(Company, :count).by(-1)
      expect(response.status).to eq 204
    end
  end
end