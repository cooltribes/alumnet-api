require 'rails_helper'

describe V1::UserController, type: :request do
  let!(:user) { User.make! }

  describe "GET /me" do
    it "return the current user" do
      get me_path, {}, basic_header(user.api_token)
      expect(response.status).to eq 200
      expect(json).to have_key('email')
      expect(json['email']).to eq(user.email)
    end
  end

  describe "GET /me/profile" do
    before do
      user.profile.first_name = "First Name"
      user.profile.last_name = "Last Name"
      user.profile.born = Date.parse("21-08-1980")
      user.profile.save
    end

    it "return the user profile" do
      profile = user.profile
      get me_profile_path, {}, basic_header(user.api_token)
      expect(response.status).to eq 200
      expect(json).to eq({"first_name"=> profile.first_name, "id" => profile.id,
        "last_name" => profile.last_name, "born" => profile.born.strftime("%Y-%m-%d"),
        "register_step" => profile.register_step})
    end
  end

  describe "PUT /me/profile" do

    it "update the user profile" do
      put me_profile_path, { first_name: "Armando", last_name: "Mendoza" }, basic_header(user.api_token)
      expect(response.status).to eq 200
      expect(json).to eq({"first_name"=> "Armando", "id" => user.profile.id,
        "last_name" => "Mendoza", "born" => nil, "register_step" => 0})
    end
  end

end