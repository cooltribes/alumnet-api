require 'rails_helper'

RSpec.describe Comments::CreateComment, type: :service do

  def valid_attributes
    user_ids = []
    3.times { user_ids << User.make!.id }
    { comment: "Neque dicta enim quasi. Qui corrupti est quisquam consectetur sapiente.",
      user_tags_list: user_ids }
  end

  it "should create a comment and update user_tags if param user_tags_list is given" do
    commentable = Post.make!
    user = User.make!
    service = Comments::CreateComment.new(commentable, user, valid_attributes)
    expect(service.call).to eq(true)
    expect(service.comment.user_tags.count).to eq(3)
  end

end