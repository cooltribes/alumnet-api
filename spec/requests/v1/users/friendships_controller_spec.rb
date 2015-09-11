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
    it "return a friendships accepted if current_user can see friends of user" do
      action = PrivacyAction.make!(name: "see-friends")
      Privacy.make!(privacy_action: action, user: user, value: 2)
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
      get friends_user_friendships_path(user), {}, basic_header(current_user.auth_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(3)
    end
    it "return a empty array if current_user can not see friends of user" do
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
      get friends_user_friendships_path(user), {}, basic_header(current_user.auth_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(0)
    end
  end
end