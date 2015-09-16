require 'rails_helper'

describe V1::UsersController, type: :request do
  let!(:admin) { User.make! }

  def user_file
    fixture_file_upload("#{Rails.root}/spec/fixtures/user_test.png")
  end

  def valid_attributes
    { email: "test_email@gmail.com", password: "12345678A", password_confirmation: "12345678A",
      avatar: user_file, name: "name test" }
  end

  def invalid_attributes
    { email: "", password: "12345678A", password_confirmation: "12345678A" }
  end

  describe "GET /users" do
    before do
      5.times do
        u = User.make!
        u.profile.set_last_register_step!
        u.activate!
        ContactInfo.make!(:email, contactable: u.profile )
      end
    end

    it "return all users" do
      get users_path, {}, basic_header(admin.auth_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(6) #with the admin
    end
  end

  describe "GET /users/:id" do
    it "return a user by id" do
      user = User.make!
      ContactInfo.make!(:email, contactable: user.profile )
      get user_path(user), {}, basic_header(admin.auth_token)
      expect(response.status).to eq 200
      expect(json).to have_key('email')
      expect(json['email']).to eq(user.permit_email(admin))
    end
  end

  describe "PUT /users/:id" do
    it "edit a user" do
      user = User.make!
      ContactInfo.make!(:email, contactable: user.profile )
      put user_path(user), { email: "test_email@gmail.com" }, basic_header(admin.auth_token)
      expect(response.status).to eq 200
      user.reload
      expect(user.email).to eq("test_email@gmail.com")
    end
  end

  describe "DELETE /users/:id" do
    it "delete a user" do
      user = User.make!
      expect {
        delete user_path(user), {}, basic_header(admin.auth_token)
      }.to change(User, :count).by(-1)
      expect(response.status).to eq 204
    end
  end
end