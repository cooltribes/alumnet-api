require 'rails_helper'

describe V1::Me::PrivaciesController, type: :request do
  let!(:current_user) { User.make! }

  describe "GET /me/privacies" do

    before do
      3.times { Privacy.make!(user: current_user) }
    end

    it "return all privacies of current user" do
      get me_privacies_path, {}, basic_header(current_user.auth_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(3)
    end
  end

  describe "POST /me/privacies" do
    context "with valid attributes" do
      it "create a privacy in current user" do
        privacy_action = PrivacyAction.make!
        expect {
          post me_privacies_path, {privacy_action_id: privacy_action.id, value: 2}, basic_header(current_user.auth_token)
        }.to change(Privacy, :count).by(1)
        expect(response.status).to eq 201
        privacy = current_user.privacies.last
        expect(privacy.privacy_action).to eq(privacy_action)
        expect(privacy.user).to eq(current_user)
        expect(privacy.value).to eq(2)
      end
    end
  end

  describe "PUT /me/privacies/:id" do
    it "edit a privacy of current user" do
      privacy = Privacy.make!(user: current_user)
      put me_privacy_path(privacy), { value: 0 }, basic_header(current_user.auth_token)
      expect(response.status).to eq 200
      privacy.reload
      expect(privacy.value).to eq(0)
    end
  end

  describe "DELETE /me/privacies/:id" do
    it "delete a privacy of current user" do
      privacy = Privacy.make!(user: current_user)
      expect {
        delete me_privacy_path(privacy), {}, basic_header(current_user.auth_token)
      }.to change(Privacy, :count).by(-1)
      expect(response.status).to eq 204
    end
  end
end