require 'rails_helper'

describe V1::Me::RegistrationController, type: :request do

  before do
    @current_user = User.make!(profile: nil)
    @profile = @current_user.profile
  end

  describe 'GET me/registration' do

    context "no given step in params" do
      it "check the user register step and return all info of step" do
        get me_registration_path, {}, basic_header(@current_user.auth_token)
        expect(response.status).to eq(200)
        expect(json).to eq({"current_step"=>"initial"})
      end
    end

  end

  describe 'PUT me/registration' do

    context "no given step in params" do
      it "check the user register step and update the data" do
        put me_registration_path, {}, basic_header(@current_user.auth_token)
        expect(response.status).to eq(200)
        expect(json).to eq({"current_step"=>"initial"})
      end
    end

  end
end

