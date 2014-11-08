require 'rails_helper'

describe V1::ProfilesController, type: :request do
  let!(:user) { User.make!(password: "12345678") }

  describe "GET /users/:user_id:/profile" do
    before do
      user.profile.first_name = "First Name"
      user.profile.last_name = "Last Name"
      user.profile.born = Date.parse("21-08-1980")
      user.profile.save
    end

    it "return the user profile" do
      profile = user.profile
      get user_profile_path(user), {}, basic_header(user.api_token)
      expect(response.status).to eq 200
      expect(json).to eq({"first_name"=> profile.first_name, "id" => profile.id,
        "last_name" => profile.last_name, "born" => profile.born.strftime("%Y-%m-%d"),
        "register_step" => profile.register_step})
    end
  end

  describe "PUT /users/:user_id:/profile" do

    it "update the user profile" do
      put user_profile_path(user), { first_name: "Armando", last_name: "Mendoza" }, basic_header(user.api_token)
      expect(response.status).to eq 200
      expect(json).to eq({"first_name"=> "Armando", "id" => user.profile.id,
        "last_name" => "Mendoza", "born" => nil, "register_step" => "profile"})
    end
  end
end