require 'rails_helper'

describe V1::Me::RegistrationController, type: :request do

  before do
    @current_user = User.make!
    @profile = @current_user.profile
  end

  describe 'GET me/registration' do

    context "no given step in params" do
      it "check the user register step and return all info of step" do
        get me_registration_path, {}, basic_header(@current_user.auth_token)
        expect(response.status).to eq(200)
        expect(json).to eq({"current_step"=>Profile.register_steps.keys.first})
      end
    end

  end

  describe 'PUT me/registration' do

    context "no given step in params" do
      it "update to next register step" do
        put me_registration_path, {}, basic_header(@current_user.auth_token)
        expect(response.status).to eq(200)
        expect(json).to eq({"current_step"=>Profile.register_steps.keys.second})
      end
    end

  end

  describe 'PUT me/registration/step' do

    context "valid params" do
      it "update register step" do
        put step_me_registration_path, { register_step: "completed"}, basic_header(@current_user.auth_token)
        expect(response.status).to eq(200)
        expect(json).to eq({"current_step"=>"completed"})
      end
    end

    context "invalid params" do
      it "not update register step" do
        put step_me_registration_path, { register_step: "xxxcompleted"}, basic_header(@current_user.auth_token)
        expect(response.status).to eq(422)
        expect(json["errors"]).to eq(["is not a valid register_step"])
      end
    end
  end
end

