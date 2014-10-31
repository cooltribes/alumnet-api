require 'rails_helper'

describe V1::UsersController, type: :request do
  let!(:user) { User.make!(password: "12345678") }

  def header
    { 'Accept' => 'application/vnd.alumnet+json;version=1' }
  end

  describe "POST /sign_in" do
    context "with valid credentials" do
      it "return the user" do
        post sign_in_path, { email: user.email, password: "12345678" }, header
        expect(response.status).to eq 200
        expect(json).to eq({"id"=>user.id, "email"=>user.email, "api_token"=>user.api_token,
          "name"=>user.name})
      end
    end

    context "with invalid credentials" do
      it "return the user" do
        post sign_in_path, { email: user.email, password: "123456dd78" }, header
        expect(response.status).to eq 401
        expect(json).to eq({"error"=>"email or password are incorrect"})
      end
    end

    context "without credentials" do
      it "return the user" do
        post sign_in_path, {}, header
        expect(response.status).to eq 401
        expect(json).to eq({"error"=>"must provide credentials"})
      end
    end
  end
end