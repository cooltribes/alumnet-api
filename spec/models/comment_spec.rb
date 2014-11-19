require 'rails_helper'

RSpec.describe Comment, :type => :model do
  it { should have_many(:likes) }
  it { should belong_to(:user) }
  it { should belong_to(:commentable) }

  describe "Calbacks" do
    describe "set_last_comment_at_in_post" do
      it "should set the datetime when comment is created in last_comment_at column of post" do
        group = Group.make!
        post = Post.make!(postable: group)
        comment = Comment.make(commentable: post)
        comment.save
        expect(post.last_comment_at).to eq(comment.created_at)
      end
    end
  end
end