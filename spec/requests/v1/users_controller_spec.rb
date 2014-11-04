require 'rails_helper'

describe V1::UsersController, type: :request do
  let!(:admin) { User.make! }

  def user_file
    fixture_file_upload("#{Rails.root}/spec/fixtures/user_test.png")
  end

  def valid_attributes
    { email: "test_email@gmail.com", password: "12345678", password_confirmation: "12345678",
      avatar: user_file, name: "name test" }
  end

  def invalid_attributes
    { email: "", password: "12345678", password_confirmation: "12345678" }
  end

  describe "GET /users" do
    before do
      5.times { User.make! }
    end

    it "return all users" do
      get users_path, {}, basic_header(admin.api_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(6)
    end
  end

  describe "GET /users/:id" do
    it "return a user by id" do
      user = User.make!
      get user_path(user), {}, basic_header(admin.api_token)
      expect(response.status).to eq 200
      expect(json).to have_key('email')
      expect(json['email']).to eq(user.email)
    end
  end

  describe "GET /users/me" do
    it "return the current user" do
      get me_users_path, {}, basic_header(admin.api_token)
      expect(response.status).to eq 200
      expect(json).to have_key('email')
      expect(json['email']).to eq(admin.email)
    end
  end

  describe "PUT /users/1" do
    it "edit a user" do
      user = User.make!
      put user_path(user), { email: "test_email@gmail" }, basic_header(admin.api_token)
      expect(response.status).to eq 200
      user.reload
      expect(user.email).to eq("test_email@gmail")
    end
  end

  describe "DELETE /users/1" do
    it "delete a user" do
      user = User.make!
      expect {
        delete user_path(user), {}, basic_header(admin.api_token)
      }.to change(User, :count).by(-1)
      expect(response.status).to eq 204
    end
  end

  describe "POST /users/1/invite" do
    context "user can invite" do
      it "create a membership mode invitation for the user and the given group" do
        inviter_user = User.make!(email: "fcoarmandomendoza@gmail.com")
        group = Group.make!
        Membership.create_membership_for_creator(group, inviter_user)
        user = User.make!
        post invite_user_path(user), { group_id: group.id }, basic_header(inviter_user.api_token)
        expect(response.status).to eq 200
        expect(user.memberships.count).to eq(1)
        expect(user.memberships.last.mode).to eq("invitation")
        expect(user.mailbox.notifications.count).to eq(1)
        expect(ActionMailer::Base.deliveries).to_not be_empty
      end
    end
    context "user cannot invite" do
      it "return unauthorize response" do
        inviter_user = User.make!
        group = Group.make!
        user = User.make!
        post invite_user_path(user), { group_id: group.id }, basic_header(inviter_user.api_token)
        expect(response.status).to eq 401
      end
    end
  end
end