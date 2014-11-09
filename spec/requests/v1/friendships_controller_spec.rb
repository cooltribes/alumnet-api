require 'rails_helper'

describe V1::UsersController, type: :request do
  let!(:user) { User.make! }

  describe "POST /friendships" do
    it "should create a friendships for current user" do
      friend = User.make!
      expect {
        post friendships_path, { friend_id: friend.id } , basic_header(user.api_token)
      }.to change(Friendship, :count).by(1)
      expect(response.status).to eq 201
      expect(user.friendships.last.accepted).to eq(false)
      expect(user.friends.to_a).to eq([friend])
      expect(json["friend_id"]).to eq(friend.id)
      expect(json["user_id"]).to eq(user.id)
    end
  end
end