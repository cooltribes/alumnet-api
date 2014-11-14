require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of(:password).on(:create) }

  it { should have_many(:memberships) }
  it { should have_many(:friendships) }
  it { should have_many(:groups).through(:memberships) }
  it { should have_many(:friends).through(:friendships) }
  it { should have_many(:posts) }
  it { should have_many(:likes) }
  it { should have_one(:profile) }

  describe "callbacks" do
    it "should set a api_key on save" do
      user = User.make
      user.save
      expect(user.api_token).to_not be_blank
    end
  end

  describe "instance methods" do
    describe "is_friend_of" do
      it "return true if uses is a friend" do
        user = User.make!
        friend = User.make!
        inverse_friend = User.make!
        not_friend = User.make!
        Friendship.make!(:accepted, user: user, friend: friend)
        Friendship.make!(:accepted, user: inverse_friend, friend: user )
        expect(user.is_friend_of?(friend)).to eq true
        expect(user.is_friend_of?(inverse_friend)).to eq true
        expect(user.is_friend_of?(not_friend)).to eq false

      end
    end

    describe "has_like_in?(likeable)" do
      it "it return true if user has a like record in the likeable model" do
        post = Post.make!
        user = User.make!
        expect(user.has_like_in?(post)).to eq(false)
        Like.make!(user: user, likeable: post)
        expect(user.has_like_in?(post)).to eq(true)
      end
    end
  end

end
