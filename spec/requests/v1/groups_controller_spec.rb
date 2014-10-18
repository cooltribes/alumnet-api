require 'rails_helper'

describe V1::GroupsController, type: :request do
  let!(:admin) { User.make! }

  def avatar_file
    fixture_file_upload("#{Rails.root}/spec/fixtures/avatar_test.jpg")
  end

  def valid_attributes
    { name: "Group 1", description: "short description", avatar: avatar_file }
  end

  def invalid_attributes
    { name: "", description: "short description", avatar: avatar_file }
  end

  describe "GET /groups" do

    before do
      parent = Group.make!
      5.times { Group.make!(parent: parent) }
    end

    it "return all groups" do
      get groups_path, {}, basic_header(admin.api_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(6)
      #TODO: Validate schema with null value. Groups without parents and children
      #expect(valid_schema('group-array', json)).to be_empty
    end
  end

  describe "GET /groups/:id" do
    it "return a group by id" do
      group = Group.make!(:with_parent_and_childen)
      get group_path(group), {}, basic_header(admin.api_token)
      expect(response.status).to eq 200
      expect(json).to have_key('name')
      expect(json).to have_key('official')
      expect(json).to have_key('parent')
      expect(json).to have_key('children')
      expect(json['children'].count).to eq(2)
      #expect(valid_schema('group', json)).to be_empty
    end
  end

  describe "POST /groups/:id/add_group" do
    it "create a new group on given group" do
      group = Group.make!
      post add_group_group_path(group), valid_attributes , basic_header(admin.api_token)
      expect(response.status).to eq 201
      group.reload
      expect(group.children.count).to eq(1)
    end
  end

  describe "POST /groups" do
    context "with valid attributes" do
      it "create a group and membership for user" do
        expect {
          post groups_path, valid_attributes , basic_header(admin.api_token)
        }.to change(Group, :count).by(1)
        expect(response.status).to eq 201
        #expect(valid_schema('group', json)).to be_empty
        expect(admin.memberships.last.mode).to eq("creation")
        expect(admin.groups).to eq([Group.last])
      end
    end

    context "with invalid attributes" do
      it "return the errors in format json" do
        expect {
          post groups_path, invalid_attributes, basic_header(admin.api_token)
        }.to change(Group, :count).by(0)
        expect(json).to eq({"name"=>["can't be blank"]})
        expect(response.status).to eq 422
      end
    end
  end

  describe "PUT /groups/1" do
    it "edit a group" do
      group = Group.make!(:with_parent_and_childen)
      put group_path(group), { name: "New name group" }, basic_header(admin.api_token)
      expect(response.status).to eq 200
      group.reload
      expect(group.name).to eq("New name group")
      #expect(valid_schema('group', json)).to be_empty
    end
  end

  describe "DELETE /groups/1" do
    it "delete a group" do
      group = Group.make!
      expect {
        delete group_path(group), {}, basic_header(admin.api_token)
      }.to change(Group, :count).by(-1)
      expect(response.status).to eq 204
    end
  end
end