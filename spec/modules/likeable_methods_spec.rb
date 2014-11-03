require 'rails_helper'

### to test with post
Post.include LikeableMethods

RSpec.describe LikeableMethods, :type => :module do
  describe "#likes_count" do
    it "return the numbers of like of likeable" do
      post = Post.make!
      Like.make!(likeable: post)
      expect(post.likes_count).to eq(1)
    end
  end

  describe "#add_like_by(user)" do
    context "user dont has a like on likeable" do
      it "user add a like to likeable and return a valid like record" do
        user = User.make!
        post = Post.make!
        like = post.add_like_by(user)
        expect(like).to be_valid
        expect(like.user).to eq(user)
      end
    end

    context "user has a like on likeable" do
      it "cant add a like and return an invalid like record" do
        user = User.make!
        post = Post.make!
        Like.make!(user: user, likeable: post)
        like = post.add_like_by(user)
        expect(like).to_not be_valid
        expect(like.errors[:user_id]).to eq(["The user already made like!"])
      end
    end
  end

  describe "#remove_like_of(user)" do
    context "user dont has a like on likeable" do
      it "return like record valid" do
        user = User.make!
        post = Post.make!
        expect(post.remove_like_of(user)).to eq(false)
      end
    end

    context "user has a like on likeable" do
      it "remove like of likeable and return true" do
        user = User.make!
        post = Post.make!
        Like.make!(user: user, likeable: post)
        expect(post.remove_like_of(user)).to eq(true)
        expect(post.likes_count).to eq(0)
      end
    end
  end
end