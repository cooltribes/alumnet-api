require 'rails_helper'

describe V1::Groups::MembershipsController, type: :request do
  let!(:group) { Group.make! }
  let!(:user) { User.make! }

  describe "GET /groups/:id/memberships" do
    it "return a memberships not approved yet" do
      3.times { Membership.make!(:not_approved, group: group ) }
      3.times { Membership.make!(:approved, group: group ) }
      get group_memberships_path(group),{}, basic_header(user.auth_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(3)
    end
  end

  describe "GET /groups/:id/memberships/members" do
    it "return a members accepted" do
      5.times { Membership.make!(:approved, group: group ) }
      get members_group_memberships_path(group), {}, basic_header(user.auth_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(5)
    end
  end

  describe "POST /groups/:id/memberships" do
    it "should create a membership" do
      user_to_invite = User.make!
      expect {
        post group_memberships_path(group), { user_id: user_to_invite.id } , basic_header(user.auth_token)
      }.to change(Membership, :count).by(1)
      expect(response.status).to eq 201
      expect(json["group"]["id"]).to eq(group.id)
      expect(json["user"]["id"]).to eq(user_to_invite.id)
    end
  end

  describe "PUT /groups/:id/memberships/:id" do
    it "should update a memberships" do
      membership = Membership.make!(:not_approved, group: group )
      put group_membership_path(group, membership), { approved: true }, basic_header(user.auth_token)
      expect(json["approved"]).to eq(true)
    end

    ###TODO: test when user is admin of group
  end

  describe "DELETE /groups/:id/memberships/:id" do
    it "delete a membership of group" do
      membership = Membership.make!(:not_approved, group: group )
      expect {
        delete group_membership_path(group, membership), {}, basic_header(user.auth_token)
      }.to change(Membership, :count).by(-1)
      expect(response.status).to eq 204
    end
  end
end