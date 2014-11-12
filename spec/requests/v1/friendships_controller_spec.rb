require 'rails_helper'

describe V1::UsersController, type: :request do
  let!(:user) { User.make! }

  describe "GET /friendships" do
    it "with filter='sent' return a friendships filtered" do
      2.times { Friendship.make!(:accepted, user: user ) }
      3.times { Friendship.make!(:not_accepted, user: user ) }
      get friendships_path, { filter: "sent" }, basic_header(user.api_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(5)
    end

    it "with filter='received' return a friendships filtered" do
      1.times { Friendship.make!(:accepted, friend: user ) }
      2.times { Friendship.make!(:not_accepted, friend: user ) }
      get friendships_path, { filter: "received" }, basic_header(user.api_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(3)
    end
  end

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

  describe "PUT /friendships/:id" do
    it "should update a friendship to accepted" do
      requester = User.make!
      friend = User.make!
      friendship = Friendship.make!(:not_accepted, user: requester, friend: friend)
      expect(friendship).to_not be_accepted
      put friendship_path(friendship), {}, basic_header(friend.api_token)
      friendship.reload
      expect(friendship).to be_accepted
    end
  end
end