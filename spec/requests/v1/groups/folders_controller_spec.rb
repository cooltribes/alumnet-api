require 'rails_helper'

describe V1::Groups::FoldersController, type: :request do
  let!(:current_user) { User.make! }
  let!(:group) { Group.make! }

  def valid_attributes
    { name: "New Folder" }
  end

  def invalid_attributes
    { name: "" }
  end

  describe "GET /groups/:group_id/folders" do

    before do
      3.times { Folder.make!(folderable: group)  }
    end

    it "return all folders of group" do
      get group_folders_path(group), {}, basic_header(current_user.auth_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(3)
    end
  end

  describe "POST /groups/:group_id/folders" do
    context "with valid attributes" do
      it "create a folder in group" do
        expect {
          post group_folders_path(group), valid_attributes , basic_header(current_user.auth_token)
        }.to change(Folder, :count).by(1)
        expect(response.status).to eq 201
        expect(json['name']).to eq("New Folder")
        expect(json['creator']['id']).to eq(current_user.id)
        expect(json['folderable_id']).to eq(group.id)
        expect(json['folderable_type']).to eq("Group")
      end
    end

    context "with invalid attributes" do
      it "return the errors in format json" do
        expect {
          post group_folders_path(group), invalid_attributes, basic_header(current_user.auth_token)
        }.to change(Folder, :count).by(0)
        expect(json).to eq({"name"=>["can't be blank"]})
        expect(response.status).to eq 422
      end
    end
  end

  describe "PUT /groups/:group_id/folders/:id" do
    it "edit a folder of group" do
      folder = Folder.make!(folderable: group, creator: current_user)
      put group_folder_path(group, folder), { name: "New name of Folder" }, basic_header(current_user.auth_token)
      expect(response.status).to eq 200
      expect(json["name"]).to eq("New name of Folder")
    end
  end

  describe "DELETE /groups/:group_id/folders/:id" do
    it "delete a folder of group" do
      folder = Folder.make!(folderable: group, creator: current_user)
      expect {
        delete group_folder_path(group, folder), {}, basic_header(current_user.auth_token)
      }.to change(Folder, :count).by(-1)
      expect(response.status).to eq 204
    end
  end
end