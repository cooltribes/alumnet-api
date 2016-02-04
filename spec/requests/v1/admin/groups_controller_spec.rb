require 'rails_helper'

describe V1::Admin::GroupsController, type: :request do
  let!(:admin) { User.make!(:admin) }
  let!(:user) { User.make! }
  let!(:country) { Country.make! }
  let!(:city) { City.make! }

  def cover_file
    fixture_file_upload("#{Rails.root}/spec/fixtures/cover_test.jpg")
  end

  def valid_attributes
    { name: "Group 1", short_description: "short description", cover: cover_file,
      country_id: country.id, city_id: city.id, join_process: 0 }
  end

  describe "GET admin/groups" do
    before do
      5.times { Group.make! }
    end
    context "if user is admin" do
      it "return all groups" do
        get admin_groups_path, {}, basic_header(admin.auth_token)
        expect(response.status).to eq 200
        expect(json.count).to eq(5)
      end
    end

    context "if user is regular" do
      it "return 204 response" do
        get admin_groups_path, {}, basic_header(user.auth_token)
        expect(response.status).to eq 204
      end
    end
  end

  describe "GET admin/groups/:id" do
    it "return a group by id" do
      group = Group.make!
      get admin_group_path(group), {}, basic_header(admin.auth_token)
      expect(response.status).to eq 200
      expect(json).to have_key('description')
      expect(json['description']).to eq(group.description)
    end
  end

  describe "GET /groups/:id/subgroups" do
    it "return all children of group" do
      group = Group.make!(:with_parent_and_childen)
      get subgroups_admin_group_path(group), {}, basic_header(admin.auth_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(2)
      expect(json.first["name"]).to eq(group.children.first.name)
    end
  end

  describe "POST admin/groups" do
    context "with valid attributes" do
      it "create a group and membership for user" do
        expect {
          post admin_groups_path, valid_attributes, basic_header(admin.auth_token)
        }.to change(Group, :count).by(1)
        expect(response.status).to eq 201
        expect(admin.groups).to eq([Group.last])
      end
    end
  end

  describe "PUT admin/groups/:id" do
    it "edit a group" do
      group = Group.make!
      put admin_group_path(group), { name: "New Name of Group" }, basic_header(admin.auth_token)
      expect(response.status).to eq 200
      group.reload
      expect(group.name).to eq("New Name of Group")
    end
  end

  describe "DELETE admin/groups/:id" do
    it "delete a group" do
      group = Group.make!
      expect {
        delete admin_group_path(group), {}, basic_header(admin.auth_token)
      }.to change(Group, :count).by(-1)
      expect(response.status).to eq 204
    end
  end
end