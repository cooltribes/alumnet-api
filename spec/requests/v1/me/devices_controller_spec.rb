require 'rails_helper'

describe V1::Me::DevicesController, type: :request do
  let!(:current_user) { User.make! }

  describe "GET /me/privacies" do

    before do
      3.times { Device.make!(user: current_user) }
    end

    it "return all devices of current user" do
      get me_devices_path, {}, basic_header(current_user.auth_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(3)
    end
  end

  describe "POST /me/devices" do
    context "with valid attributes" do
      it "create a new device in current user" do
        expect {
          post me_devices_path, { platform: "android", token: "GCMTOKEN"}, basic_header(current_user.auth_token)
        }.to change(current_user.devices, :count).by(1)
        expect(response.status).to eq 201
        expect(json["platform"]).to eq("android")
        expect(json["token"]).to eq("GCMTOKEN")
        expect(json["active"]).to eq(true)
      end
    end
  end
end