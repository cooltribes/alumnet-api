require 'rails_helper'

describe V1::Me::GroupsController, type: :request do
  let!(:current_user) { User.make! }

  describe "GET /me/groups" do
    it "should return all groups where the current user is the creator" do
      3.times do
        Group.make!(creator: current_user)
      end
      3.times do
        Group.make!(creator: User.make!)
      end
      Group.make!(creator: current_user, name: "Testing Search")

      get me_groups_path, {}, basic_header(current_user.auth_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(4)
    end
  end
end