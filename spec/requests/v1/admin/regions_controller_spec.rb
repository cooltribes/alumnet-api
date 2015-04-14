require 'rails_helper'

describe V1::Admin::RegionsController, type: :request do
  let!(:user) { User.make!(:admin) }

  describe "GET admin/regions" do
    it "return all regions" do
      3.times { Region.make! }
      get admin_regions_path, {}, basic_header(user.auth_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(3)
    end
  end

  describe "GET admin/regions/:id" do
    it "return region by id" do
      region = Region.make!
      get admin_region_path(region), {}, basic_header(user.auth_token)
      expect(response.status).to eq 200
      expect(json["name"]).to eq(region.name)
    end
  end

  describe "POST admin/regions" do
    it "create a new region" do
      3.times { Country.make! }
      countries_ids = Country.all.pluck(:id)
      expect {
        post admin_regions_path, { name: "Region Test", country_ids: countries_ids }, basic_header(user.auth_token)
      }.to change(Region, :count).by(1)
      expect(response.status).to eq 201
      expect(Region.last.name).to eq("Region Test")
      expect(Region.last.countries.count).to eq(5) # + 2 by user.
    end
  end

  describe "PUT admin/regions/:id" do
    it "edit a region" do
      region = Region.make!
      put admin_region_path(region), { name: "New Name" }, basic_header(user.auth_token)
      region.reload
      expect(response.status).to eq 200
      expect(json['name']).to eq("New Name")
      expect(region.name).to eq("New Name")
    end
  end

  describe "DELETE admin/regions/:id" do
    it "delete a region" do
      region = Region.make!
      expect {
        delete admin_region_path(region), {}, basic_header(user.auth_token)
      }.to change(Region, :count).by(-1)
      expect(response.status).to eq 204
    end
  end
end