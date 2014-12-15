require 'rails_helper'

describe V1::ResetPasswordsController, type: :request do
  let!(:user) { User.make!(password: "12345678") }

  def header
    { 'Accept' => 'application/vnd.alumnet+json;version=1' }
  end

  describe "POST /reset_passwords" do
    context "with valid credentials" do
      it "return a message and send a email with instructions" do
        post reset_passwords_path, { email: user.email }, header
        expect(response.status).to eq 200
        expect(json).to eq({"message"=>"Email sent with password reset instructions"})
        ### test the mail
      end
    end

    context "with invalid credentials" do
      it "return a error message" do
        post reset_passwords_path, { email: "armando@gmail.com" }, header
        expect(response.status).to eq 401
        expect(json).to eq({"error"=>"email not registered"})
      end
    end

    context "without credentials" do
      it "return a error message" do
        post reset_passwords_path, { email: "" }, header
        expect(response.status).to eq 401
        expect(json).to eq({"error"=>"must provide credentials"})
      end
    end
  end

end