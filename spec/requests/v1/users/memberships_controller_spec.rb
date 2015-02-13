require 'rails_helper'

describe V1::Groups::MembershipsController, type: :request do
  let!(:group) { Group.make! }
  let!(:user) { User.make! }

  describe "GET /users/:id/memberships" do
    it "return a memberships not approved yet" do
      3.times { Membership.make!(:not_approved, user: user ) }
      3.times { Membership.make!(:not_approved ) }
      get user_memberships_path(user),{}, basic_header(user.auth_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(3)
    end
  end

  describe "GET /users/:id/memberships/groups" do
    it "return a groups of user" do
      5.times { Membership.make!(:approved, user: user ) }
      get groups_user_memberships_path(user), {}, basic_header(user.auth_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(5)
    end
  end

  describe "POST /users/:id/memberships" do
    ###TODO: FIX this
    context "group is open" do
      it "should create a membership approved" do
        group_to_join = Group.make!
        group_to_join.open!
        expect {
          post user_memberships_path(user), { group_id: group_to_join.id } , basic_header(user.auth_token)
        }.to change(Membership, :count).by(1)
        expect(response.status).to eq 201
        expect(json["group"]["id"]).to eq(group_to_join.id)
        expect(json["user"]["id"]).to eq(user.id)
        # expect(json["approved"]).to eq(true)
      end
    end
    context "group is closed o secred" do
      it "should create a membership approved" do
        group_to_join = Group.make!
        group_to_join.closed!
        expect {
          post user_memberships_path(user), { group_id: group_to_join.id } , basic_header(user.auth_token)
        }.to change(Membership, :count).by(1)
        expect(response.status).to eq 201
        expect(json["group"]["id"]).to eq(group_to_join.id)
        expect(json["user"]["id"]).to eq(user.id)
        expect(json["approved"]).to eq(false)
      end
    end
  end

  describe "PUT /users/:id/memberships/:id" do
    it "should update a memberships" do
      membership = Membership.make!(:not_approved, user: user )
      put user_membership_path(user, membership), { approved: true }, basic_header(user.auth_token)
      expect(json["approved"]).to eq(true)
    end
  end

  describe "DELETE /users/:id/memberships/:id" do
    it "delete a membership of group" do
      membership = Membership.make!(:not_approved, user: user )
      expect {
        delete user_membership_path(user, membership), {}, basic_header(user.auth_token)
      }.to change(Membership, :count).by(-1)
      expect(response.status).to eq 204
    end
  end
end