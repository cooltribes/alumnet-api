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
        "register_step" => profile.register_step, "birth_city"=> nil, "residence_city"=> nil})
    end
  end

  describe "PUT /users/:user_id:/profile" do
    context "Step 1, initial" do
      it "update the user profile" do
        put user_profile_path(user), { first_name: "Armando", last_name: "Mendoza" }, basic_header(user.api_token)
        expect(response.status).to eq 200
        expect(json).to eq({"first_name"=> "Armando", "id" => user.profile.id,
          "last_name" => "Mendoza", "born" => nil, "register_step" => "profile", "birth_city"=> nil, "residence_city"=> nil})
      end
    end

    context "Step 2, profile" do
      before do
        user.profile.first_name = "First Name"
        user.profile.last_name = "Last Name"
        user.profile.born = Date.parse("21-08-1980")
        user.profile.save
      end
      it "should add many contact info to profile" do
        contact_infos_attributes = { contact_infos_attributes: [
          { "contact_type" => 1, "info" => "twiter", "privacy" => 1 },
          { "contact_type" => 1, "info" => "facebook", "privacy" => 1 },
          { "contact_type" => 1, "info" => "linkedin", "privacy" => 1 },
          { "contact_type" => 1, "info" => "instagram", "privacy" => 1 }
        ]}
        profile = user.profile
        profile.profile! #change the estatus
        put user_profile_path(user), contact_infos_attributes, basic_header(user.api_token)
        expect(response.status).to eq 200
        profile.reload
        expect(profile.contact_infos.count).to eq(4)
        expect(profile.contact_infos.pluck(:info)).to match_array(["twiter", "facebook", "linkedin", "instagram"])
      end
    end
  end
end