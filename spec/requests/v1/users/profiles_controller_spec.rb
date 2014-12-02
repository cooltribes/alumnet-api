require 'rails_helper'

describe V1::Users::ProfilesController, type: :request do

  before do
    @user = User.make!
  end

  describe "GET /me/profile" do
    it "return the user profile" do
      profile = @user.profile
      profile.first_name = "Armando"
      profile.save
      get user_profile_path(@user, profile), {}, basic_header(@user.auth_token)
      expect(response.status).to eq 200
      expect(json['first_name']).to eq(profile.first_name)
    end
  end

  describe "PUT /me/profile" do
    it "update the user profile" do
      profile = @user.profile
      put user_profile_path(@user, profile), { first_name: "Armando", last_name: "Mendoza" }, basic_header(@user.auth_token)
      expect(response.status).to eq 200
      expect(json['first_name']).to eq('Armando')
      expect(json['last_name']).to eq('Mendoza')
    end
  end
end

