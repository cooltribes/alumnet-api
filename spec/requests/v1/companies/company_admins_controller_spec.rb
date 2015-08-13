require 'rails_helper'

describe V1::Companies::CompanyAdminsController, type: :request do
  let!(:user) { User.make! }
  let!(:other_user) { User.make! }

  def valid_attributes
   { "user_id"  => other_user.id }
  end

  before do
    @company = Company.make!
  end

  describe "GET /companies/:id/company_admins" do
    it "return all company_admins of company" do
      3.times do
        user = User.make!
        CompanyAdmin.create(user: user, company: @company)
      end
      get company_company_admins_path(@company), {}, basic_header(user.auth_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(3)
    end
  end

  describe "POST /companies/:id/company_admins" do
    context "if user is company admin" do
      it "create a new accepted company_admin on given company" do
        CompanyAdmin.create(company: @company, user: user, status: 1)
        post company_company_admins_path(@company), valid_attributes , basic_header(user.auth_token)
        expect(response.status).to eq 201
        expect(json["user_id"]).to eq(other_user.id)
        expect(json["company_id"]).to eq(@company.id)
        expect(json["status"]).to eq("accepted")
        expect(json["accepted_by"]).to eq(user.id)
      end
    end
    context "if user is company admin" do
      it "create a new sent company_admin on given company" do
        post company_company_admins_path(@company), valid_attributes , basic_header(user.auth_token)
        expect(response.status).to eq 201
        expect(json["user_id"]).to eq(other_user.id)
        expect(json["company_id"]).to eq(@company.id)
        expect(json["status"]).to eq("sent")
        expect(json["accepted_by"]).to eq(nil)
      end
    end
  end

  describe "PUT /companies/:id/company_admins/:id" do
    context "if user is company admin" do
      it "update an company_admin on given company" do
        CompanyAdmin.create(company: @company, user: user, status: 1)
        company_admin = CompanyAdmin.create(user: other_user, company: @company)
        put company_company_admin_path(@company, company_admin), {} , basic_header(user.auth_token)
        expect(response.status).to eq 200
        expect(json['status']).to eq("accepted")
      end
    end
    context "if user is regular" do
      it "cannot update an company_admin on given company" do
        company_admin = CompanyAdmin.create(user: other_user, company: @company)
        put company_company_admin_path(@company, company_admin), {} , basic_header(user.auth_token)
        expect(response.status).to eq 403
      end
    end
  end

  describe "DELETE /companies/:id/company_admins/:id" do
    context "if user is company admin" do
      it "delete a company_admin" do
        CompanyAdmin.create(company: @company, user: user, status: 1)
        company_admin = CompanyAdmin.create(user: other_user, company: @company)
        expect {
          delete company_company_admin_path(@company, company_admin), {}, basic_header(user.auth_token)
        }.to change(CompanyAdmin, :count).by(-1)
        expect(response.status).to eq 204
      end
    end
    context "if user is regular" do
      it "cannot update an company_admin on given company" do
        company_admin = CompanyAdmin.create(user: other_user, company: @company)
        delete company_company_admin_path(@company, company_admin), {}, basic_header(user.auth_token)
        expect(response.status).to eq 403
      end
    end
  end
end