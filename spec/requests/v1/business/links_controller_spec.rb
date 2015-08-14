require 'rails_helper'

describe V1::Business::LinksController, type: :request do
  let!(:current_user) { User.make! }
  let!(:business) { CompanyRelation.make! }

  def valid_attributes
    { title: "New Link", description: "description", url: "www.google.com" }
  end

  def invalid_attributes
    { title: "New Link", description: "description", url: "" }
  end

  describe "GET /business/:id/links" do

    before do
      3.times { Link.make!(linkable: business) }
    end

    it "return all links of business" do
      get business_links_path(business), {}, basic_header(current_user.auth_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(3)
    end
  end

  describe "POST /business/:id/links" do
    context "with valid attributes" do
      it "create a link in business" do
        expect {
          post business_links_path(business), valid_attributes , basic_header(current_user.auth_token)
        }.to change(Link, :count).by(1)
        expect(response.status).to eq 201
        expect(json["title"]).to eq("New Link")
        expect(json["description"]).to eq("description")
        expect(json["url"]).to eq("www.google.com")
        expect(Link.last.linkable).to eq(business)
      end
    end

    context "with invalid attributes" do
      it "return the errors in format json" do
        expect {
          post business_links_path(business), invalid_attributes, basic_header(current_user.auth_token)
        }.to change(Link, :count).by(0)
        expect(json).to eq({"url"=>["can't be blank"]})
        expect(response.status).to eq 422
      end
    end
  end

  describe "PUT /business/:id/links/:id" do
    it "edit a link of business" do
      link = Link.make!(linkable: business)
      put business_link_path(business, link), { title: "New name of Link" }, basic_header(current_user.auth_token)
      expect(response.status).to eq 200
      expect(json["title"]).to eq("New name of Link")
    end
  end

  describe "DELETE /business/:id/links/:id" do
    it "delete a link of business" do
      link = Link.make!(linkable: business)
      expect {
        delete business_link_path(business, link), {}, basic_header(current_user.auth_token)
      }.to change(Link, :count).by(-1)
      expect(response.status).to eq 204
    end
  end
end