require 'rails_helper'

RSpec.describe Post, :type => :model do
  it { should belong_to(:user) }
  it { should belong_to(:postable) }
  it { should have_many(:likes) }


  describe "acts_as_commentable" do
    it "should have methods to handle comments" do
      post = Post.make!
      expect {
        post.comments.create(comment: "It is a comment to test!", user: User.make!)
      }.to change(Comment, :count).by(1)
      expect(post.comments.last.comment).to eq("It is a comment to test!")
    end
  end
end
