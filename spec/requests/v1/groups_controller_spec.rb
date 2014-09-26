require 'spec_helper'

module V1
  describe GroupsController, type: :request do
    let!(:admin) { User.make! }

    def valid_attributes
      { name: "Group 1", description: "short description", avatar: "Avatar", group_type: 1 }
    end

    def invalid_attributes
      { name: "", description: "short description", avatar: "Avatar", group_type: 1 }
    end

    describe "GET /groups" do
      before do
        5.times { Group.make! }
      end

      it "return all groups" do
        get groups_path, {}, basic_header(admin.api_token)
        expect(response.status).to eq 200
        expect(json.count).to eq(5)
      end
    end

    describe "GET /groups/:id" do
      it "return a group by id" do
        group = Group.make!
        get group_path(group), {}, basic_header(admin.api_token)
        expect(response.status).to eq 200
        expect(json['group']).to have_key('name')
      end
    end

    describe "POST /groups" do
      context "with valid attributes" do
        it "create a group" do
          expect {
            post groups_path, { group: valid_attributes }, basic_header(admin.api_token)
          }.to change(Group, :count).by(1)
          expect(response.status).to eq 201
        end
      end

      context "with invalid attributes" do
        it "return the errors in format json" do
          expect {
            post groups_path, { group: invalid_attributes }, basic_header(admin.api_token)
          }.to change(Group, :count).by(0)
          expect(json).to eq({"name"=>["can't be blank"]})
          expect(response.status).to eq 422
        end
      end
    end

    describe "PUT /groups/1" do
      it "create a group" do
        group = Group.make!
        put group_path(group), { group: { name: "New name group" } }, basic_header(admin.api_token)
        expect(response.status).to eq 200
        group.reload
        expect(group.name).to eq("New name group")
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
end