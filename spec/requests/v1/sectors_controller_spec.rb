require 'rails_helper'

describe V1::SectorsController, type: :request do
  let!(:user) { User.make! }

  describe "GET /sectors" do
    it "return all sectors" do
      3.times { |x| Sector.create(name: "Sector #{x}") }
      get sectors_path, {}, basic_header(user.auth_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(3)
      expect(json.last['name']).to eq("Sector 2")
    end
  end
end