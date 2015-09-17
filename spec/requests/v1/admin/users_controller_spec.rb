require 'rails_helper'

describe V1::Admin::UsersController, type: :request do
  let!(:admin) { User.make!(role: User::ROLES[:system_admin]) }
  let!(:user) { User.make! }

  describe "GET admin/users" do
    before do
      5.times { User.make! }
    end
    context "if user is admin" do
      it "return all users" do
        get admin_users_path, {}, basic_header(admin.auth_token)
        expect(response.status).to eq 200
        expect(json.count).to eq(7)
      end
    end

    context "if user is regular" do
      it "return 204 response" do
        get admin_users_path, {}, basic_header(user.auth_token)
        expect(response.status).to eq 204
      end
    end
  end

  describe "GET admin/users/:id" do
    it "return a user by id" do
      user = User.make!
      get admin_user_path(user), {}, basic_header(admin.auth_token)
      expect(response.status).to eq 200
      expect(json).to have_key('email')
      expect(json['email']).to eq(user.email)
    end
  end

  describe "POST admin/users/:id/note" do
    it "create or update the admin note of user" do
      user = User.make!
      expect(user.admin_note).to be_nil
      post note_admin_user_path(user), { note: "This is a note for test" }, basic_header(admin.auth_token)
      expect(response.status).to eq 200
      user.reload
      expect(user.admin_note.body).to eq("This is a note for test")
    end
  end

  describe "PUT admin/users/:id/activate" do
    it "change the status of user to active, change register step of profile to approval and return user" do
      stub_request(:post, "https://us10.api.mailchimp.com/2.0/lists/merge-vars.json").
        with(:body => "{\"id\":{\"id\":\"testing\"},\"apikey\":\"f0ad0e019703b02132b2cf15ad458e50-us10\"}",
             :headers => {'Content-Type'=>'application/json', 'Host'=>'us10.api.mailchimp.com:443', 'User-Agent'=>'excon/0.45.4'}).
        to_return(:status => 200, :body => "{\"data\": [\"XXXX\"]}", :headers => {})
        ###Arreglar el response boy de acuerdo con lo que espera mailchimp
      user_inactive = User.make!(status: 0)
      user_inactive.profile.set_last_register_step!
      put activate_admin_user_path(user_inactive), {}, basic_header(admin.auth_token)
      expect(response.status).to eq 200
      expect(json["status"]["text"]).to eq("active")
      expect(json["profileData"]["register_step"]).to eq("approval")
    end
  end

  describe "PUT admin/users/:id" do
    it "edit a user" do
      user = User.make!
      put admin_user_path(user), { tag_list: "tag, xp, linux" }, basic_header(admin.auth_token)
      expect(response.status).to eq 200
      user.reload
      expect(user.tag_list).to eq(["linux", "xp", "tag"])
    end
  end

  describe "PUT admin/user/:id/change_role" do
    it "change the role of user" do
      user = User.make!
      expect(user.role).to eq(User::ROLES[:regular])
      put change_role_admin_user_path(user), { role: "alumnet"}, basic_header(admin.auth_token)
      expect(response.status).to eq 200
      user.reload
      expect(user.role).to eq(User::ROLES[:alumnet_admin])
      put change_role_admin_user_path(user), { role: "regular"}, basic_header(admin.auth_token)
      expect(response.status).to eq 200
      user.reload
      expect(user.role).to eq(User::ROLES[:regular])
    end
  end

  describe "DELETE admin/users/:id" do
    it "delete a user" do
      user = User.make!
      expect {
        delete admin_user_path(user), {}, basic_header(admin.auth_token)
      }.to change(User, :count).by(-1)
      expect(response.status).to eq 204
    end
  end

  describe "POST /admin/users/register" do
    context "with valid attributes" do
      it "create a new user" do
        expect {
          post register_admin_users_path, { email: "test_email@gmail.com", role: "external" }, basic_header(admin.auth_token)
        }.to change(User, :count).by(1)
        expect(response.status).to eq 201
        user = User.last
        expect(user.email).to eq("test_email@gmail.com")
        expect(user.role).to eq(User::ROLES[:external])
        expect(user.created_by_admin).to eq(true)
      end
    end
  end
end