require 'rails_helper'
include ActiveSupport::Testing::TimeHelpers

describe V1::PasswordResetsController, type: :request do
  let!(:user) { User.make!(password: "12345678A") }

  def header
    { 'Accept' => 'application/vnd.alumnet+json;version=1' }
  end

  describe "POST /password_resets" do
    context "with valid credentials" do
      it "return a message and send a email with instructions" do
        post password_resets_path, { email: user.email }, header
        expect(response.status).to eq 200
        expect(json).to eq({"message"=>"Email sent with password reset instructions"})
        ### test the mail
      end
    end

    context "with invalid credentials" do
      it "return a error message" do
        post password_resets_path, { email: "armando@gmail.com" }, header
        expect(response.status).to eq 401
        expect(json).to eq({ "errors"=> {"email" => ["not registered"]} })
      end
    end

    context "without credentials" do
      it "return a error message" do
        post password_resets_path, { email: "" }, header
        expect(response.status).to eq 401
        expect(json).to eq({ "errors"=> {"email" => ["must provide credentials"]} })
      end
    end
  end

  describe "PUT /password_resets" do
    context "with valid token" do
      it "return a message and update the password of user" do
        user.send_password_reset
        token = user.password_reset_token
        put password_reset_path(token), { password: "314460978A",
          password_confirmation: "314460978A" }, header
        expect(response.status).to eq 200
        expect(json).to eq({"message"=>"Password has been reset"})
      end
    end

    context "with expired token" do
      it "return a error message and not update the password of user" do
        user.send_password_reset
        token = user.password_reset_token
        travel 2.hour
        put password_reset_path(token), { password: "314460978",
          password_confirmation: "314460978" }, header
        expect(response.status).to eq 401
        expect(json).to eq({"errors"=> { "token" => ["has expired"]} })
        travel_back
      end
    end

    context "with expired token" do
      it "return a error message and not update the password of user" do
        put password_reset_path("UNEXISTENTTOKEN"), { password: "314460978",
          password_confirmation: "314460978" }, header
        expect(response.status).to eq 401
        expect(json).to eq({"errors"=> { "token" => ["is invalid"]}})
      end
    end

    context "Other errors" do
      it "return a error message and not update the password of user" do
        user.send_password_reset
        token = user.password_reset_token
        put password_reset_path(token), { password: "3333314460978",
          password_confirmation: "314460978" }, header
        expect(response.status).to eq 401
        expect(json).to eq({"errors"=>{"password_confirmation"=>["doesn't match Password"],
          "password"=>["must be a combination of numbers and letters"]}})
      end
    end
  end
end