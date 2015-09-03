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
    describe "notify_to_users" do
      it "should creata a notifications to members or assistants of postable" do
        # group = Group.make!
        # author = User.make!
        # member = User.make!
        # Membership.create_membership_for_creator(group, author)
        # group.build_membership_for(member, true).save
        # post = Post.make(postable: group, user: member)
        # post.save
      end
    end
  end
end
