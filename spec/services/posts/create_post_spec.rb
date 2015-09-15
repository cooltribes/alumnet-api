require 'rails_helper'

RSpec.describe Posts::CreatePost, type: :service do

  def valid_attributes
    user_ids = []
    3.times { user_ids << User.make!.id }
    { body: "Neque dicta enim quasi. Qui corrupti est quisquam consectetur sapiente.",
      user_tags_list: user_ids }
  end

  it "should create a post and update user_tags if param user_tags_list is given" do
    postable = Group.make!
    user = User.make!
    service = Posts::CreatePost.new(postable, user, valid_attributes)
    expect(service.call).to eq(true)
    expect(service.post.user_tags.count).to eq(3)
  end

end