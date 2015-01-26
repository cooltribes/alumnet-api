require 'rails_helper'

describe V1::Users::FriendshipsController, type: :request do
  let!(:user) { User.make! }
  let!(:current_user) { User.make! }

  describe "GET /user/:id/friendships" do
    it "with filter='sent' return a friendships filtered" do
      2.times { Friendship.make!(:accepted, user: user ) }
      3.times { Friendship.make!(:not_accepted, user: user ) }
      get user_friendships_path(user), { filter: "sent" }, basic_header(current_user.auth_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(3)
    end

    it "with filter='received' return a friendships filtered" do
      1.times { Friendship.make!(:accepted, friend: user ) }
      2.times { Friendship.make!(:not_accepted, friend: user ) }
      get user_friendships_path(user), { filter: "received" }, basic_header(current_user.auth_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(2)
    end
  end

  describe "GET /user/:id/friendships/friends" do
    it "return a friendships accepted" do
      2.times { Friendship.make!(:accepted, user: user ) }
      1.times { Friendship.make!(:accepted, friend: user ) }
      get friends_user_friendships_path(user), {}, basic_header(current_user.auth_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(3)
    end
  end
end