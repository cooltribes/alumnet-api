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

  it "should create a comment and send email to users that liked or commented in commentable" do
    commentable = Post.make! #Picture.make!
    armando = User.make!
    yondri = User.make!
    nelson = User.make!
    commentable.add_like_by(yondri)
    commentable.add_like_by(nelson)
    service = Comments::CreateComment.new(commentable, armando, valid_attributes)
    expect {
      service.call
    }.to enqueue_a(ActionMailer::DeliveryJob).times(2)

  end

end