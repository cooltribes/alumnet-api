require 'rails_helper'

describe V1::Users::ProfilesController, type: :request do

  before do
    @user = User.make!
    @user.profile.first_name = "Armando"
    @user.profile.last_name = "Mendoza"
    @user.profile.born = Date.parse("21-08-1980")
    @user.profile.gender = "M"
    @user.profile.save
    @profile = @user.profile
  end

  describe "GET /users/:id/profile" do
    it "return the user profile" do
      get user_profile_path(@user, @profile), {}, basic_header(@user.auth_token)
      expect(response.status).to eq 200
      expect(json['first_name']).to eq(@profile.first_name)
    end
  end

  describe "PUT /users/:id/profile" do
    it "update the user profile" do
      put user_profile_path(@user, @profile), { first_name: "Armando", last_name: "Mendoza" }, basic_header(@user.auth_token)
      expect(response.status).to eq 200
      expect(json['first_name']).to eq('Armando')
      expect(json['last_name']).to eq('Mendoza')
    end
  end
end

