require 'rails_helper'

describe V1::Companies::LinksController, type: :request do
  let!(:current_user) { User.make! }
  let!(:company) { Company.make! }

  def valid_attributes
    { title: "New Link", description: "description", url: "www.google.com" }
  end

  def invalid_attributes
    { title: "New Link", description: "description", url: "" }
  end

  describe "GET /company/:id/links" do

    before do
      3.times { Link.make!(linkable: company) }
    end

    it "return all links of company" do
      get company_links_path(company), {}, basic_header(current_user.auth_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(5) #3 created above and 2 created by the blueprint of company
    end
  end

  describe "POST /company/:id/links" do
    context "with valid attributes" do
      it "create a link in company" do
        expect {
          post company_links_path(company), valid_attributes , basic_header(current_user.auth_token)
        }.to change(Link, :count).by(1)
        expect(response.status).to eq 201
        expect(json["title"]).to eq("New Link")
        expect(json["description"]).to eq("description")
        expect(json["url"]).to eq("www.google.com")
        expect(Link.last.linkable).to eq(company)
      end
    end

    context "with invalid attributes" do
      it "return the errors in format json" do
        expect {
          post company_links_path(company), invalid_attributes, basic_header(current_user.auth_token)
        }.to change(Link, :count).by(0)
        expect(json).to eq({"url"=>["can't be blank"]})
        expect(response.status).to eq 422
      end
    end
  end

  describe "PUT /company/:id/links/:id" do
    it "edit a link of company" do
      link = Link.make!(linkable: company)
      put company_link_path(company, link), { title: "New name of Link" }, basic_header(current_user.auth_token)
      expect(response.status).to eq 200
      expect(json["title"]).to eq("New name of Link")
    end
  end

  describe "DELETE /company/:id/links/:id" do
    it "delete a link of company" do
      link = Link.make!(linkable: company)
      expect {
        delete company_link_path(company, link), {}, basic_header(current_user.auth_token)
      }.to change(Link, :count).by(-1)
      expect(response.status).to eq 204
    end
  end
end