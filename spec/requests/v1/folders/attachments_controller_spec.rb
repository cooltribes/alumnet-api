require 'rails_helper'

describe V1::Folders::AttachmentsController, type: :request do
  let!(:current_user) { User.make! }
  let!(:folder) { Folder.make! }

  def attachment_file
    fixture_file_upload("#{Rails.root}/spec/fixtures/contacts.csv")
  end

  def valid_attributes
    { name: "New Attachment", file: attachment_file }
  end

  def invalid_attributes
    { name: "New Attachment", file: "" }
  end

  describe "GET /folders/:folder_id/attachments" do

    before do
      3.times { Attachment.make!(folder: folder)  }
    end

    it "return all attachments of folder" do
      get folder_attachments_path(folder), {}, basic_header(current_user.auth_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(3)
    end
  end

  describe "POST /folders/:folder_id/attachments" do
    context "with valid attributes" do
      it "create a folder in folder" do
        expect {
          post folder_attachments_path(folder), valid_attributes , basic_header(current_user.auth_token)
        }.to change(Attachment, :count).by(1)
        expect(response.status).to eq 201
        expect(json['name']).to eq("New Attachment")
        expect(json['uploader']['id']).to eq(current_user.id)
        expect(json['folder_id']).to eq(folder.id)
      end
    end

    context "with invalid attributes" do
      it "return the errors in format json" do
        expect {
          post folder_attachments_path(folder), invalid_attributes, basic_header(current_user.auth_token)
        }.to change(Attachment, :count).by(0)
        expect(json).to eq({"file"=>["can't be blank"]})
        expect(response.status).to eq 422
      end
    end
  end

  describe "PUT /folders/:folder_id/attachments/:id" do
    it "edit an attachment of folder" do
      attachment = Attachment.make!(folder: folder, uploader: current_user)
      put folder_attachment_path(folder, attachment), { name: "New name of Attachment" }, basic_header(current_user.auth_token)
      expect(response.status).to eq 200
      expect(json["name"]).to eq("New name of Attachment")
    end
  end

  describe "DELETE /folders/:folder_id/attachment/:id" do
    it "delete an attachment of folder" do
      attachment = Attachment.make!(folder: folder, uploader: current_user)
      expect {
        delete folder_attachment_path(folder, attachment), {}, basic_header(current_user.auth_token)
      }.to change(Attachment, :count).by(-1)
      expect(response.status).to eq 204
    end
  end
end