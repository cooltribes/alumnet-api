require 'rails_helper'

describe V1::MeController, type: :request do
  let!(:user) { User.make! }

  describe "GET /user" do
    it "return the authenticate user" do
      get me_path, {}, basic_header(user.auth_token)
      expect(response.status).to eq 200
      expect(json).to have_key('email')
      expect(json['email']).to eq(user.email)
    end
  end

  describe "PUT /user" do
    it "update data of authenticate user" do
      put me_path, { email: 'new_email@email.com'}, basic_header(user.auth_token)
      expect(response.status).to eq 200
      expect(json).to have_key('email')
      expect(json['email']).to eq('new_email@email.com')
    end
  end
end