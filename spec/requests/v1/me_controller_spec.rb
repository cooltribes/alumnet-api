require 'rails_helper'

describe V1::MeController, type: :request do
  let!(:user) { User.make! }


  describe "GET /me" do
    before do
      stub_request(:post, "http://apistaging.profinda.com/api/auth/sign_in").
        with(:body => "{\"user\":{\"email\":\"#{user.email}\",\"password\":\"#{user.profinda_password}\"}}",
         :headers => {'Accept'=>'application/vnd.profinda+json;version=1', 'Content-Type'=>'application/json', 'Profindaaccountdomain'=>'cooltribes-staging.profinda.com'}).
        to_return(:status => 200, :body => "{\"authentication_token\":\"token\"}", :headers => {})
    end
    it "return the authenticate user" do
      get me_path, {}, basic_header(user.auth_token)
      expect(response.status).to eq 200
      expect(json).to have_key('email')
      expect(json['email']).to eq(user.email)
    end
  end

  describe "GET /me/receptive_settings" do
    it "return the settings for receptive.io integration" do
      get receptive_settings_me_path, {}, basic_header(user.auth_token)
      expect(response.status).to eq 200
    end
  end

  describe "PUT /me" do
    before do
      stub_request(:post, "http://apistaging.profinda.com/api/auth/sign_in").
        with(:body => "{\"user\":{\"email\":\"new_email@email.com\",\"password\":\"#{user.profinda_password}\"}}",
         :headers => {'Accept'=>'application/vnd.profinda+json;version=1', 'Content-Type'=>'application/json', 'Profindaaccountdomain'=>'cooltribes-staging.profinda.com'}).
        to_return(:status => 200, :body => "{\"authentication_token\":\"token\"}", :headers => {})
    end
    it "update data of authenticate user" do
      put me_path, { email: 'new_email@email.com'}, basic_header(user.auth_token)
      expect(response.status).to eq 200
      expect(json).to have_key('email')
      expect(json['email']).to eq('new_email@email.com')
    end
  end

  describe "POST /activate" do
    context "with a regular user" do
      it "active user if user completed the penultimate and was created by an admin" do
        user = User.make!(status: 0, role: User::ROLES[:regular], created_by_admin: true)
        user.profile.aiesec_experiences!
        post activate_me_path, {}, basic_header(user.auth_token)
        expect(response.status).to eq 200
        expect(json["status"]).to eq("active")
        user.reload
        expect(user.status).to eq("active")
      end
    end
    context "with a external user" do
      it "active user if user completed the languages_and_skills step and was created by an admin" do
        user = User.make!(email: "external_user_test@cooltribes.com", status: 0, role: User::ROLES[:external], created_by_admin: true)
        user.profile.languages_and_skills!
        post activate_me_path, {}, basic_header(user.auth_token)
        expect(response.status).to eq 200
        expect(json["status"]).to eq("active")
        user.reload
        expect(user.status).to eq("active")
      end
    end
  end
end