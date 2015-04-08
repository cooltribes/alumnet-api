require 'rails_helper'

describe V1::RegionsController, type: :request do
  let!(:user) { User.make! }

  describe "GET /regions" do
    it "return all regions" do
      3.times { Region.make! }
      get regions_path, {}, basic_header(user.auth_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(3) #+2 of bluprint of user
    end
  end

  describe "GET /regions/:id" do
    it "return region by id" do
      region = Region.make!
      get region_path(region), {}, basic_header(user.auth_token)
      expect(response.status).to eq 200
      expect(json["name"]).to eq(region.name)
    end
  end
end