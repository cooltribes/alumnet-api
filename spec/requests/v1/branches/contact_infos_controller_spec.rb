require 'rails_helper'

describe V1::Branches::ContactInfosController, type: :request do
  let!(:user) { User.make! }

  def valid_attributes
   { "contact_type"  => 0, "info" => "armando@hotmail.com", "privacy" => 1 }
  end

  before do
    @branch = Branch.make!
  end

  describe "GET /branches/:id/contact_infos" do
    it "return all contact infos of branch" do
      3.times { ContactInfo.make!(:email, contactable: @branch) }
      get branch_contact_infos_path(@branch), {}, basic_header(user.auth_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(3)
    end
  end

  describe "POST /branches/:id/contact_infos" do
    it "create a new contact_info on given branch" do
      post branch_contact_infos_path(@branch), valid_attributes , basic_header(user.auth_token)
      expect(response.status).to eq 201
      expect(json["contact_type"]).to eq(0)
      expect(json["info"]).to eq("armando@hotmail.com")
      expect(json["privacy"]).to eq(1)
      expect(json["contactable_type"]).to eq("Branch")
    end
  end

  describe "PUT /branches/:id/contact_infos/:id" do
    it "update an contact_info on given branch" do
      contact_info = ContactInfo.make!(:email, contactable: @branch)
      put branch_contact_info_path(@branch, contact_info), { info: "francisco@hotmail.com"} , basic_header(user.auth_token)
      expect(response.status).to eq 200
      expect(json["info"]).to eq("francisco@hotmail.com")
    end
  end

  describe "DELETE /branches/:id/contact_infos/:id" do
    it "delete a contact_info" do
      contact_info = ContactInfo.make!(:email, contactable: @branch)
      expect {
        delete branch_contact_info_path(@branch, contact_info), {}, basic_header(user.auth_token)
      }.to change(ContactInfo, :count).by(-1)
      expect(response.status).to eq 204
    end
  end
end