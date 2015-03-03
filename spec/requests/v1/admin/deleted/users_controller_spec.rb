require 'rails_helper'

describe V1::Admin::Deleted::UsersController, type: :request do
  let!(:admin) { User.make!(:admin) }
  let!(:user) { User.make! }


  describe "GET admin/users" do
    before do
      5.times { User.make! }
    end

    context "if user is admin" do
      it "return all deleted users" do
        User.last.destroy
        User.last.destroy
        get admin_deleted_users_path, {}, basic_header(admin.auth_token)
        expect(response.status).to eq 200
        expect(json.count).to eq(2)
      end
    end

    context "if user is regular" do
      it "return 204 response" do
        get admin_deleted_users_path, {}, basic_header(user.auth_token)
        expect(response.status).to eq 204
      end
    end
  end

  describe "PUT admin/users/:id" do
    it "restore a user by id" do
      user = User.make!
      user.destroy
      put admin_deleted_user_path(user), {}, basic_header(admin.auth_token)
      expect(response.status).to eq 200
      expect(json).to have_key('email')
      expect(json['email']).to eq(user.email)
    end
  end

  describe "DELETE admin/users/:id" do
    it "delete a user from database" do
      user = User.make!
      user.destroy
      expect {
        delete admin_deleted_user_path(user), {}, basic_header(admin.auth_token)
      }.to change(User.with_deleted, :count).by(-1)
      expect(response.status).to eq 204
    end
  end
end