require 'rails_helper'

describe V1::Users::FriendsController, type: :request do
  let!(:user) { User.make! }

  describe "GET /users/:id/friends" do
    before do
      4.times { Friendship.make!(:accepted, user: user) }
      Friendship.make!(:accepted, friend: user) ##test search in inverse_friends
    end

    it "return all comments of the posts" do
      get user_friends_path(user), {}, basic_header(user.api_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(5)
    end
  end

end