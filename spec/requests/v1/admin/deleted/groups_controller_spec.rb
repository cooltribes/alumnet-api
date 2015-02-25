require 'rails_helper'

describe V1::Admin::Deleted::GroupsController, type: :request do
  let!(:admin) { User.make!(:admin) }
  let!(:user) { User.make! }


  describe "GET admin/groups" do
    before do
      5.times { Group.make! }
    end

    context "if user is admin" do
      it "return all deleted groups" do
        Group.first.destroy
        Group.last.destroy
        get admin_deleted_groups_path, {}, basic_header(admin.auth_token)
        expect(response.status).to eq 200
        expect(json.count).to eq(2)
      end
    end

    context "if user is regular" do
      it "return 204 response" do
        get admin_deleted_groups_path, {}, basic_header(user.auth_token)
        expect(response.status).to eq 204
      end
    end
  end

  describe "GET admin/groups/:id/restore" do
    it "restore a group by id" do
      group = Group.make!
      group.destroy
      get restore_admin_deleted_group_path(group), {}, basic_header(admin.auth_token)
      expect(response.status).to eq 200
      expect(json).to have_key('description')
      expect(json['description']).to eq(group.description)
    end
  end

  describe "DELETE admin/groups/:id" do
    it "delete a group from database" do
      group = Group.make!
      group.destroy
      expect {
        delete admin_deleted_group_path(group), {}, basic_header(admin.auth_token)
      }.to change(Group.with_deleted, :count).by(-1)
      expect(response.status).to eq 204
    end
  end
end