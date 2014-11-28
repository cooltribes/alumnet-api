require 'rails_helper'
## access to post info.

describe V1::PostsController, type: :request do
  let!(:admin) { User.make! }
  let!(:group) { Group.make! }

  describe "GET /posts/:id" do
    it "return a post by id" do
      post = Post.make!(postable: Group.make!)
      get post_path(post), {}, basic_header(admin.auth_token)
      expect(response.status).to eq 200
      expect(json).to have_key('body')
      #expect(valid_schema('post', json)).to be_empty
    end
  end

  describe "POST /posts/:id/like" do
    context "without like from user" do
      it "add like a post" do
        user = User.make!
        post_model = Post.make!(postable: group)
        expect {
          post like_post_path(post_model), {}, basic_header(user.auth_token)
        }.to change(post_model, :likes_count).by(1)
        expect(response.status).to eq 200
        expect(json).to have_key("user_id")
      end
    end

    context "with like from user" do
      it "return a json with error" do
        user = User.make!
        post_model = Post.make!(postable: group)
        Like.make!(user: user, likeable: post_model)
        expect {
          post like_post_path(post_model), {}, basic_header(user.auth_token)
        }.to change(post_model, :likes_count).by(0)
        expect(response.status).to eq 422
        expect(json['errors']).to eq(["User already made like!"])
      end
    end
  end

  describe "POST /posts/:id/unlike" do
    context "with a like" do
      it "remove like of post" do
        user = User.make!
        post_model = Post.make!(postable: group)
        Like.make!(user: user, likeable: post_model)
        expect {
          post unlike_post_path(post_model), {}, basic_header(user.auth_token)
        }.to change(post_model, :likes_count).by(-1)
        expect(json["ok"]).to eq(true)
        expect(response.status).to eq 200
      end
    end
  end
end