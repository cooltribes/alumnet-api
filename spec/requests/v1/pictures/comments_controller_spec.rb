require 'rails_helper'

describe V1::Pictures::CommentsController, type: :request do
  let!(:admin) { User.make! }
  let!(:picture) { Picture.make! }

  def valid_attributes
    { comment: "Neque dicta enim quasi. Qui corrupti est quisquam." }
  end

  def invalid_attributes
    { comment: "" }
  end

  describe "GET /pictures/:picture_id/comments" do
    before do
      5.times { Comment.make!(commentable: picture) }
    end

    it "return all comments of the pictures" do
      get picture_comments_path(picture), {}, basic_header(admin.auth_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(5)
      #TODO: Validate schema with null value. Groups without parents and children
      #expect(valid_schema('comments-array', json)).to be_empty
    end
  end

  describe "GET /pictures/:picture_id/comments/:id" do
    it "return a comment of post by id" do
      comment = Comment.make!(commentable: picture)
      get picture_comment_path(picture, comment), {}, basic_header(admin.auth_token)
      expect(response.status).to eq 200
      expect(json).to have_key('user')
      expect(json).to have_key('comment')
      expect(json).to have_key('created_at')
      #expect(valid_schema('group', json)).to be_empty
    end
  end

  describe "POST /pictures/:picture_id/comments" do
    context "with valid attributes" do
      it "create a comment in post" do
        expect {
          post picture_comments_path(picture), valid_attributes, basic_header(admin.auth_token)
        }.to change(Comment, :count).by(1)
        expect(response.status).to eq 201
        comment = picture.comments.last
        expect(comment.comment).to eq(valid_attributes[:comment])
        expect(comment.user).to eq(admin)
        #expect(valid_schema('comment', json)).to be_empty
      end
    end

    context "with invalid attributes" do
      it "return the errors in format json" do
        expect {
          post picture_comments_path(picture), invalid_attributes, basic_header(admin.auth_token)
        }.to change(Comment, :count).by(0)
        expect(json).to eq({"comment"=>["can't be blank"]})
        expect(response.status).to eq 422
      end
    end
  end

  describe "PUT /pictures/:picture_id/comments/:id" do
    it "edit a comment of post" do
      comment = Comment.make!(commentable: picture, user: admin)
      put picture_comment_path(picture, comment), { comment: "New text in comment" }, basic_header(admin.auth_token)
      expect(response.status).to eq 200
      comment.reload
      expect(comment.comment).to eq("New text in comment")
      #expect(valid_schema('group', json)).to be_empty
    end
  end

  describe "DELETE /pictures/:picture_id/comments/:id" do
    it "delete a post of group" do
      comment = Comment.make!(commentable: picture, user: admin)
      expect {
        delete picture_comment_path(picture, comment), {}, basic_header(admin.auth_token)
      }.to change(Comment, :count).by(-1)
      expect(response.status).to eq 204
    end
  end

  describe "POST /pictures/:picture_id/commment/:id/like" do
    context "without like from user" do
      it "add like a comment" do
        user = User.make!
        picture = Picture.make!
        comment = Comment.make!(commentable: picture, user: user)
        expect {
          post like_picture_comment_path(picture, comment), {}, basic_header(user.auth_token)
        }.to change(comment, :likes_count).by(1)
        expect(response.status).to eq 200
        expect(json).to have_key("user_id")
      end
    end

    context "with like from user" do
      it "return a json with error" do
        user = User.make!
        picture = Picture.make!
        comment = Comment.make!(commentable: picture, user: user)
        Like.make!(user: user, likeable: comment)
        expect {
          post like_picture_comment_path(picture, comment), {}, basic_header(user.auth_token)
        }.to change(comment, :likes_count).by(0)
        expect(response.status).to eq 422
        expect(json['errors']).to eq(["User already made like!"])
      end
    end
  end
end