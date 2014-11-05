require 'rails_helper'

describe V1::ProfilesController, type: :request do
  let!(:user) { User.make!(password: "12345678") }

  def valid_attributes
    { email: "test_email@gmail.com", password: "12345678", password_confirmation: "12345678",
      name: "name test" }
  end

  def invalid_attributes
    { email: "", password: "12345678", password_confirmation: "12345678" }
  end

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
      expect(json["user"]).to eq({"name"=> user.name, "email"=> user.email})
      expect(json["profile"]).to eq({"first_name"=> profile.first_name,
        "last_name" => profile.last_name, "born" => profile.born.strftime("%Y-%m-%d"),
        "register_step" => profile.register_step})
    end
  end

  describe "PUT /users/:user_id:/profile" do

    it "return the user profile" do
      put user_profile_path(user), { first_name: "Armando" }, basic_header(user.api_token)
      expect(response.status).to eq 200
      expect(json["user"]).to eq({"name"=> user.name, "email"=> user.email})
      expect(json["profile"]).to eq({"first_name"=> "Armando",
        "last_name" => nil, "born" => nil, "register_step" => 0})
    end
  end


end