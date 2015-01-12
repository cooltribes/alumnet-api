require 'rails_helper'

describe V1::Profiles::ExperiencesController, type: :request do
  let!(:user) { User.make! }

  def valid_attributes
    { "exp_type" => 0, "name" => "Name", "description" => "Description",
      "start_date" => "2011-01-01", "end_date" => "2012-01-01",
      "city_id" => 1 , "country_id" => 20 }
  end

  before do
    @profile = user.profile
  end

  describe "GET /profiles/:id/experiences" do
    it "return all experiences of profile" do
      3.times { Experience.make!(profile: @profile) }
      get profile_experiences_path(@profile), {}, basic_header(user.auth_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(3)
    end
  end

  describe "POST /profiles/:id/experiences" do
    it "create a new experience on given profile" do
      post profile_experiences_path(@profile), valid_attributes , basic_header(user.auth_token)
      expect(response.status).to eq 201
      expect(json["name"]).to eq("Name")
      expect(json["description"]).to eq("Description")
    end
  end

  describe "PUT /profiles/:id/experiences/:id" do
    it "update an experience on given profile" do
      experience = Experience.make!(profile: @profile)
      put profile_experience_path(@profile, experience), { name: "New Experience Name"} , basic_header(user.auth_token)
      expect(response.status).to eq 200
      expect(json["name"]).to eq("New Experience Name")
    end
  end

  describe "DELETE /profiles/:id/experiences/:id" do
    it "delete a experience" do
      experience = Experience.make!(profile: @profile)
      expect {
        delete profile_experience_path(@profile, experience), {}, basic_header(user.auth_token)
      }.to change(Experience, :count).by(-1)
      expect(response.status).to eq 204
    end
  end
end