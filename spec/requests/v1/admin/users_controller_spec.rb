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
      it "return all users" do
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

  describe "PUT admin/users/:id/activate" do
    it "change the status of user to active, change register step of profile to approval and return user" do
      user = User.make!
      user.profile.skills!
      post activate_admin_user_path(user), {}, basic_header(admin.auth_token)
      expect(response.status).to eq 200
      expect(json["status"]).to eq("active")
      expect(json["profile"]["register_step"]).to eq("approval")
    end
  end

  describe "PUT admin/users/:id" do
    it "edit a user" do
      user = User.make!
      put admin_user_path(user), { email: "test_email@gmail.com" }, basic_header(admin.auth_token)
      expect(response.status).to eq 200
      user.reload
      expect(user.email).to eq("test_email@gmail.com")
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
end