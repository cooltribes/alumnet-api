require 'rails_helper'

describe V1::GroupsController, type: :request do
  let!(:user) { User.make! }
  let!(:country) { Country.make! }
  let!(:city) { country.cities.last }

  def cover_file
    fixture_file_upload("#{Rails.root}/spec/fixtures/cover_test.jpg")
  end

  def valid_attributes
    { name: "Group 1", description: "description", short_description: "short description",
      cover: cover_file, country_id: country.id, city_id: city.id, join_process: 0,
      mailchimp: true, api_key: 'f0ad0e019703b02132b2cf15ad458e50-us10', list_id: "f3034576a5" }
  end

  def invalid_attributes
    { name: "", short_description: "short description", cover: cover_file,
      country_id: country.id, city_id: city.id, join_process: 0 }
  end

  def invalid_attributes_with_mailchimp
    { name: "Group 1", short_description: "short description", cover: cover_file,
      country_id: country.id, city_id: city.id, join_process: 0, mailchimp: true,
      api_key: 'HHHHHHH', list_id: "dsd" }
  end

  describe "GET /groups" do

    before do
      parent = Group.make!
      5.times { Group.make!(parent: parent) }
    end

    it "return all groups" do
      get groups_path, {}, basic_header(user.auth_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(6)
      #TODO: Validate schema with null value. Groups without parents and children
      #expect(valid_schema('group-array', json)).to be_empty
    end
  end

  describe "GET /groups/:id" do
    it "return a group by id" do
      group = Group.make!(:with_parent_and_childen)
      get group_path(group), {}, basic_header(user.auth_token)
      expect(response.status).to eq 200
      expect(json).to have_key('name')
      expect(json).to have_key('official')
      expect(json).to have_key('parent')
      expect(json).to have_key('children')
      expect(json['children'].count).to eq(2)
      #expect(valid_schema('group', json)).to be_empty
    end
  end

  describe "GET /groups/:id/subgroups" do
    it "return all children of group" do
      group = Group.make!(:with_parent_and_childen)
      get subgroups_group_path(group), {}, basic_header(user.auth_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(2)
      expect(json.first["name"]).to eq(group.children.first.name)
    end
  end

  describe "POST /groups/:id/add_group" do
    it "create a new group on given group" do
      group = Group.make!
      post add_group_group_path(group), valid_attributes , basic_header(user.auth_token)
      expect(response.status).to eq 201
      group.reload
      expect(group.children.count).to eq(1)
    end
  end

  describe "POST /groups" do
    context "with valid attributes" do
      it "create a group and membership for user" do
        expect {
          post groups_path, valid_attributes , basic_header(user.auth_token)
        }.to change(Group, :count).by(1)
        expect(response.status).to eq 201
        expect(user.groups).to eq([Group.last])
      end
    end

    context "with invalid attributes" do
      it "return the errors in format json" do
        expect {
          post groups_path, invalid_attributes, basic_header(user.auth_token)
        }.to change(Group, :count).by(0)
        expect(json).to eq({"name"=>["can't be blank"]})
        expect(response.status).to eq 422
      end
    end

    context "with mailchimp invalid attributes" do
      it "return the errors in format json" do
        expect {
          post groups_path, invalid_attributes_with_mailchimp, basic_header(user.auth_token)
        }.to change(Group, :count).by(0)
        expect(json).to eq( {"success"=>false, "message"=>{"api_key"=>["Invalid API Key"]}})
        expect(response.status).to eq 422
      end
    end
  end

  describe "PUT /groups/1" do
    it "edit a group" do
      group = Group.make!(:with_parent_and_childen)
      Membership.create_membership_for_creator(group, user)
      put group_path(group), { name: "New name group", short_description: "short description" }, basic_header(user.auth_token)
      expect(response.status).to eq 200
      group.reload
      expect(group.name).to eq("New name group")
      expect(group.short_description).to eq("short description")
      #expect(valid_schema('group', json)).to be_empty
    end
  end

  describe "DELETE /groups/1" do
    it "delete a group" do
      group = Group.make!
      Membership.create_membership_for_creator(group, user)
      expect {
        delete group_path(group), {}, basic_header(user.auth_token)
      }.to change(Group, :count).by(-1)
      expect(response.status).to eq 204
    end
  end
end