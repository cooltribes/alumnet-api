require 'rails_helper'

RSpec.describe Post, :type => :model do
  it { should belong_to(:user) }
  it { should belong_to(:postable) }
  it { should have_many(:likes) }

  it "should have paranoia" do
    expect(Post.paranoid?).to eq(true)
  end

  describe "acts_as_commentable" do
    it "should have methods to handle comments" do
      post = Post.make!(postable: User.make!)
      expect {
        post.comments.create(comment: "It is a comment to test!", user: User.make!)
      }.to change(Comment, :count).by(1)
      expect(post.comments.last.comment).to eq("It is a comment to test!")
    end
  end

  describe "Callbacks" do
    describe "set_type" do
      it "should set type in function of content" do
        user = User.make!
        shared_post = Post.make!(postable: user, user: user)
        expect(shared_post.post_type).to eq("regular")
        post = Post.make!(postable: user, user: user, content: shared_post)
        expect(post.content).to eq(shared_post)
        expect(post.post_type).to eq("share")
      end
    end
  end
end
