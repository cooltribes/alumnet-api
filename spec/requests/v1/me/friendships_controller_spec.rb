require 'rails_helper'

describe V1::Me::FriendshipsController, type: :request do
  let!(:user) { User.make! }

  describe "GET /me/friendships" do
    it "with filter='sent' return a friendships filtered" do
      2.times { Friendship.make!(:accepted, user: user ) }
      3.times { Friendship.make!(:not_accepted, user: user ) }
      get me_friendships_path, { filter: "sent" }, basic_header(user.auth_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(3)
    end

    it "with filter='received' return a friendships filtered" do
      1.times { Friendship.make!(:accepted, friend: user ) }
      2.times { Friendship.make!(:not_accepted, friend: user ) }
      get me_friendships_path, { filter: "received" }, basic_header(user.auth_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(2)
    end
  end

  describe "GET /me/friendships/friends" do
    it "return a friendships accepted" do
      2.times do
        friendship = Friendship.make!(:accepted, user: user)
        ContactInfo.make!(:email, contactable: user.profile )
        ContactInfo.make!(:email, contactable: friendship.friend.profile)
      end
      1.times do
        friendship = Friendship.make!(:accepted, friend: user)
        ContactInfo.make!(:email, contactable: user.profile )
        ContactInfo.make!(:email, contactable: friendship.user.profile)
      end
      get friends_me_friendships_path, {}, basic_header(user.auth_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(3)
    end
  end

  describe "POST /me/friendships" do
    it "should create a friendship" do
      friend = User.make!
      expect {
        post me_friendships_path, { friend_id: friend.id } , basic_header(user.auth_token)
      }.to change(Friendship, :count).by(1)
      expect(response.status).to eq 201
      expect(json["friend_id"]).to eq(friend.id)
      expect(json["user_id"]).to eq(user.id)
      expect(json["accepted"]).to eq(false)
      expect(json["friendship_type"]).to eq("sent")
    end
  end

  describe "PUT /me/friendships/:id" do
    it "should update a friendship to accepted" do
      requester = User.make!
      friend = User.make!
      friendship = Friendship.make!(:not_accepted, user: requester, friend: friend)
      expect(friendship).to_not be_accepted
      put me_friendship_path(friendship), {}, basic_header(friend.auth_token)
      expect(json["accepted"]).to eq(true)
    end
  end

  describe "DELETE /me/friendships/:id" do
    it "delete a friendship of current_user" do
      friendship = Friendship.make!(:not_accepted, user: user)
      expect {
        delete me_friendship_path(friendship), {}, basic_header(user.auth_token)
      }.to change(Friendship, :count).by(-1)
      expect(response.status).to eq 204
    end
  end
end