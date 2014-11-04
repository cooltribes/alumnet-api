require 'rails_helper'
### comments from post

describe V1::Posts::CommentsController, type: :request do
  let!(:admin) { User.make! }
  let!(:post_model) { Post.make! }

  def valid_attributes
    { comment: "Neque dicta enim quasi. Qui corrupti est quisquam." }
  end

  def invalid_attributes
    { comment: "" }
  end

  describe "GET /posts/:post_id/comments/:id" do
    before do
      5.times { Comment.make!(commentable: post_model) }
    end

    it "return all comments of the posts" do
      get post_comments_path(post_model), {}, basic_header(admin.api_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(5)
      #TODO: Validate schema with null value. Groups without parents and children
      #expect(valid_schema('comments-array', json)).to be_empty
    end
  end

  describe "GET /posts/:post_id/comments/:id" do
    it "return a comment of post by id" do
      comment = Comment.make!(commentable: post_model)
      get post_comment_path(post_model, comment), {}, basic_header(admin.api_token)
      expect(response.status).to eq 200
      expect(json).to have_key('user')
      expect(json).to have_key('comment')
      expect(json).to have_key('created_at')
      #expect(valid_schema('group', json)).to be_empty
    end
  end

  describe "POST /posts/:post_id/comments" do
    context "with valid attributes" do
      it "create a comment in post" do
        expect {
          post post_comments_path(post_model), valid_attributes, basic_header(admin.api_token)
        }.to change(Comment, :count).by(1)
        expect(response.status).to eq 201
        comment = post_model.comments.last
        expect(comment.comment).to eq(valid_attributes[:comment])
        expect(comment.user).to eq(admin)
        #expect(valid_schema('comment', json)).to be_empty
      end
    end

    context "with invalid attributes" do
      it "return the errors in format json" do
        expect {
          post post_comments_path(post_model), invalid_attributes, basic_header(admin.api_token)
        }.to change(Comment, :count).by(0)
        expect(json).to eq({"comment"=>["can't be blank"]})
        expect(response.status).to eq 422
      end
    end
  end

  describe "PUT /posts/:post_id/comments/:id" do
    it "edit a comment of post" do
      comment = Comment.make!(commentable: post_model)
      put post_comment_path(post_model, comment), { comment: "New text in comment" }, basic_header(admin.api_token)
      expect(response.status).to eq 200
      comment.reload
      expect(comment.comment).to eq("New text in comment")
      #expect(valid_schema('group', json)).to be_empty
    end
  end

  describe "DELETE /posts/:post_id/comments/:id" do
    it "delete a post of group" do
      comment = Comment.make!(commentable: post_model)
      expect {
        delete post_comment_path(post_model, comment), {}, basic_header(admin.api_token)
      }.to change(Comment, :count).by(-1)
      expect(response.status).to eq 204
    end
  end

end