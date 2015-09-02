require 'rails_helper'

### to test with post
Post.include UserTaggingSystem::Taggable
User.include UserTaggingSystem::Tag

RSpec.describe UserTaggingSystem, :type => :module do
  let!(:post){ Post.make! }

  it "should adding user_tags to post" do
    user_ids = []
    3.times { user_ids << User.make!.id }
    post.user_tag_ids = user_ids
    expect(post.user_tags.count).to eq(3)
  end

  it "should delete user_tags to post" do
    user_ids = []
    3.times { user_ids << User.make!.id }

    post.user_tag_ids = user_ids
    expect(post.user_tags.count).to eq(3)

    new_user_ids = [User.first.id]
    post.user_tag_ids = new_user_ids
    expect(post.user_tags.count).to eq(1)
  end

  describe "add_user_tags(users_ids, options)" do
    it "should add user_tags to taggable with tagger " do
      user_ids = []
      3.times { user_ids << User.make!.id }
      tagger = User.make
      post.add_user_tags(user_ids, tagger: tagger)
      expect(post.user_taggings.count).to eq(3)
      expect(post.user_taggings.last.tagger).to eq(tagger)
    end
  end

  describe "remove_user_tags(users_ids)" do
    it "should remove user_tags to taggable" do
      user_ids = []
      3.times { user_ids << User.make!.id }
      post.add_user_tags(user_ids.join(","))
      expect(post.user_taggings.count).to eq(3)
      post.remove_user_tags([User.last.id])
      expect(post.user_taggings.count).to eq(2)
    end
  end

  describe "update_tags(users_ids, options)" do
    it "should remove user_tags to taggable" do
      user_ids = []
      3.times { user_ids << User.make!.id }
      tagger = User.make
      post.update_user_tags(user_ids, tagger: tagger)
      expect(post.user_taggings.count).to eq(3)
      new_user_ids = [user_ids[1]]
      post.update_user_tags(new_user_ids, tagger: tagger)
      expect(post.user_taggings.count).to eq(1)
    end
  end
end