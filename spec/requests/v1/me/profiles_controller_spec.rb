require 'rails_helper'

describe V1::Me::ProfilesController, type: :request do

  describe "GET /me/profile" do
    before do
      @user = User.make!
      @user.profile.first_name = "Armando"
      @user.profile.last_name = "Mendoza"
      @user.profile.born = Date.parse("21-08-1980")
      @user.profile.save
    end

    it "return the user profile" do
      profile = @user.profile
      get me_profile_path, {}, basic_header(@user.api_token)
      expect(response.status).to eq 200
      expect(json['first_name']).to eq(profile.first_name)
      expect(json['last_name']).to eq(profile.last_name)
    end
  end

  describe "PUT /me/profile" do
    before do
      @user = User.make!
    end

    context "Step 1 - initial" do
      it "update the user profile" do
        put me_profile_path, { first_name: "Armando", last_name: "Mendoza" }, basic_header(@user.api_token)
        expect(response.status).to eq 200
        expect(json['first_name']).to eq('Armando')
        expect(json['last_name']).to eq('Mendoza')
      end
    end

    context "Step 2 - profile completed" do
      before do
        @user.profile.first_name = "Armando"
        @user.profile.last_name = "Mendoza"
        @user.profile.born = Date.parse("21-08-1980")
        @user.profile.save
      end

      it "should add many contact info to profile" do
        contact_infos_attributes = { contact_infos_attributes: [
          { "contact_type" => 1, "info" => "twiter", "privacy" => 1 },
          { "contact_type" => 1, "info" => "facebook", "privacy" => 1 },
          { "contact_type" => 1, "info" => "linkedin", "privacy" => 1 },
        ]}
        profile = @user.profile
        profile.profile! #change the estatus
        put me_profile_path(@user), contact_infos_attributes, basic_header(@user.api_token)
        expect(response.status).to eq 200
        profile.reload
        expect(profile.contact_infos.count).to eq(3)
        expect(profile.contact_infos.pluck(:info)).to match_array(["twiter", "facebook", "linkedin"])
      end
    end

    context "Step 3 - contacts completed" do
      before do
        @user.profile.first_name = "Armando"
        @user.profile.last_name = "Mendoza"
        @user.profile.born = Date.parse("21-08-1980")
        @user.profile.save
      end

      it "should add many experiences to profile" do
        experiences_attributes = { experiences_attributes: [
          {"exp_type" => 0, "name" => "Name", "description" => "Description",
           "start_date" => "2011-01-01", "end_date" => "2012-01-01",
           "city_id" => 1 , "country_id" => 20},
          {"exp_type" => 1, "name" => "Name 1", "description" => "Description 1",
           "start_date" => "2011-01-01", "end_date" => "2012-01-01",
           "city_id" => 1 , "country_id" => 20},
        ]}
        profile = @user.profile
        profile.contact! #change the estatus
        put me_profile_path(@user), experiences_attributes, basic_header(@user.api_token)
        expect(response.status).to eq 200
        profile.reload
        expect(profile.experiences.count).to eq(2)
        expect(profile.experiences.pluck(:name)).to match_array(["Name", "Name 1"])
      end
    end
  end
end

