require 'rails_helper'

describe V1::Profiles::ContactInfosController, type: :request do
  let!(:user) { User.make! }
  let!(:other) { User.make! }

  def valid_attributes
   { "contact_type"  => 0, "info" => "armando@hotmail.com", "privacy" => 1 }
  end

  before do
    @profile = user.profile
  end

  describe "GET /profiles/:id/contact_infos" do
    it "return all contact infos of profile" do
      3.times { ContactInfo.make!(:email, profile: @profile) }
      get profile_contact_infos_path(@profile), {}, basic_header(user.auth_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(3)
    end
  end

  describe "POST /profiles/:id/contact_infos" do
    it "create a new contact_info on given profile" do
      post profile_contact_infos_path(@profile), valid_attributes , basic_header(user.auth_token)
      expect(response.status).to eq 201
      expect(json["contact_type"]).to eq(0)
      expect(json["info"]).to eq("armando@hotmail.com")
      expect(json["privacy"]).to eq(1)
    end
  end

  describe "PUT /profiles/:id/contact_infos/:id" do
    it "update an contact_info on given profile" do
      contact_info = ContactInfo.make!(:email, profile: @profile)
      put profile_contact_info_path(@profile, contact_info), { info: "francisco@hotmail.com"} , basic_header(user.auth_token)
      expect(response.status).to eq 200
      expect(json["info"]).to eq("francisco@hotmail.com")
    end
  end

  describe "DELETE /profiles/:id/contact_infos/:id" do
    it "delete a contact_info" do
      contact_info = ContactInfo.make!(:email, profile: @profile)
      expect {
        delete profile_contact_info_path(@profile, contact_info), {}, basic_header(user.auth_token)
      }.to change(ContactInfo, :count).by(-1)
      expect(response.status).to eq 204
    end
  end

  context "testing authorization" do
    describe "PUT /profiles/:id/contact_infos/:id" do
      it "should not authorize the action" do
        contact_info = ContactInfo.make!(:email, profile: @profile)
        put profile_contact_info_path(@profile, contact_info), { email: "other@hotmail.com"} , basic_header(other.auth_token)
        expect(response.status).to eq 403
      end
    end
  end
end