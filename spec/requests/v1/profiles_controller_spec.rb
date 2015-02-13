require 'rails_helper'

describe V1::ProfilesController, type: :request do

  describe "GET /profile" do
    before do
      @user = User.make!
      @user.profile.first_name = "Armando"
      @user.profile.last_name = "Mendoza"
      @user.profile.born = Date.parse("21-08-1980")
      @user.profile.gender = "M"
      @user.profile.save
    end

    it "return the user profile" do
      profile = @user.profile
      get profile_path(profile), {}, basic_header(@user.auth_token)
      expect(response.status).to eq 200
      expect(json['first_name']).to eq(profile.first_name)
      expect(json['last_name']).to eq(profile.last_name)
    end
  end

  describe "PUT /profile" do
    before do
      @user = User.make!
    end
    it "update the user profile" do
      profile_attributes = {
        "birth_city_id" => 1,
        "residence_city_id" => 1,
        "birth_country_id" => 1,
        "residence_country_id" => 1,
        "gender" => "M",
        "born" => "1980-08-21",
        "first_name" => "Armando",
        "last_name" => "Mendoza"
      }
      profile = @user.profile
      put profile_path(profile), profile_attributes, basic_header(@user.auth_token)
      expect(response.status).to eq 200
      expect(json['first_name']).to eq('Armando')
      expect(json['last_name']).to eq('Mendoza')
      expect(json['born']).to eq('1980-08-21')
      expect(json['birth_country_id']).to eq(1)
      expect(json['birth_city_id']).to eq(1)
      expect(json['residence_country_id']).to eq(1)
      expect(json['birth_country_id']).to eq(1)
    end
  end

  context "testing authorization" do
    before do
      @user = User.make!
      @other = User.make!
    end

    describe "PUT /profile" do
      it "should not authorize the action" do
      profile = @user.profile
      put profile_path(profile), { "born" => ""}, basic_header(@other.auth_token)
      expect(response.status).to eq 403
      end
    end
  end
end