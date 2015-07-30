require 'rails_helper'

describe V1::MeController, type: :request do
  let!(:user) { User.make! }

  describe "GET /user" do
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

  describe "PUT /user" do
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
      it "active user if user completed the registration and was created by an admin" do
        user = User.make!(status: 0, role: User::ROLES[:regular], created_by_admin: true)
        user.profile.skills!
        post activate_me_path, {}, basic_header(user.auth_token)
        expect(response.status).to eq 200
        expect(json["status"]).to eq("active")
        user.reload
        expect(user.status).to eq("active")
      end
    end
    context "with a external user" do
      it "active user if user completed the contact step and was created by an admin" do
        user = User.make!(email: "external_user_test@cooltribes.com", status: 0, role: User::ROLES[:external], created_by_admin: true)
        user.profile.contact!
        post activate_me_path, {}, basic_header(user.auth_token)
        expect(response.status).to eq 200
        expect(json["status"]).to eq("active")
        user.reload
        expect(user.status).to eq("active")
      end
    end
  end
end