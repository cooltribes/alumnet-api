require 'rails_helper'

describe V1::Events::FoldersController, type: :request do
  let!(:current_user) { User.make! }
  let!(:event) { Event.make!(creator: current_user) }

  def valid_attributes
    { name: "New Folder" }
  end

  def invalid_attributes
    { name: "" }
  end

  describe "GET /events/:event_id/folders" do

    before do
      3.times { Folder.make!(folderable: event)  }
    end

    it "return all folders of event" do
      get event_folders_path(event), {}, basic_header(current_user.auth_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(3)
    end
  end

  describe "POST /events/:event_id/folders" do
    context "with valid attributes" do
      it "create a folder in event" do
        expect {
          post event_folders_path(event), valid_attributes , basic_header(current_user.auth_token)
        }.to change(Folder, :count).by(1)
        expect(response.status).to eq 201
        expect(json['name']).to eq("New Folder")
        expect(json['creator']['id']).to eq(current_user.id)
        expect(json['folderable_id']).to eq(event.id)
        expect(json['folderable_type']).to eq("Event")
      end
    end

    context "with invalid attributes" do
      it "return the errors in format json" do
        expect {
          post event_folders_path(event), invalid_attributes, basic_header(current_user.auth_token)
        }.to change(Folder, :count).by(0)
        expect(json).to eq({"name"=>["can't be blank"]})
        expect(response.status).to eq 422
      end
    end
  end

  describe "PUT /events/:event_id/folders/:id" do
    it "edit a folder of event" do
      folder = Folder.make!(folderable: event, creator: current_user)
      put event_folder_path(event, folder), { name: "New name of Folder" }, basic_header(current_user.auth_token)
      expect(response.status).to eq 200
      expect(json["name"]).to eq("New name of Folder")
    end
  end

  describe "DELETE /events/:event_id/folders/:id" do
    it "delete a folder of event" do
      folder = Folder.make!(folderable: event, creator: current_user)
      expect {
        delete event_folder_path(event, folder), {}, basic_header(current_user.auth_token)
      }.to change(Folder, :count).by(-1)
      expect(response.status).to eq 204
    end
  end
end