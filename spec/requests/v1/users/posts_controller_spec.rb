require 'rails_helper'
### posts from users

describe V1::Users::PostsController, type: :request do
  let!(:author) { User.make! }
  let!(:user) { User.make! }

  def valid_attributes
    { body: "Neque dicta enim quasi. Qui corrupti est quisquam. Facere animi quod aut. Qui nulla consequuntur consectetur sapiente." }
  end

  def invalid_attributes
    { body: "" }
  end

  describe "GET /users/:user_id/posts" do

    before do
      5.times { Post.make!(postable: user)  }
    end

    it "return all posts of user" do
      get user_posts_path(user), {}, basic_header(author.auth_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(5)
      #TODO: Validate schema with null value. Groups without parents and children
      #expect(valid_schema('user-array', json)).to be_empty
    end
  end

  describe "GET /users/:user_id/posts/:id" do
    it "return a post of a user by id" do
      post = Post.make!(postable: user)
      get user_post_path(user, post), {}, basic_header(author.auth_token)
      expect(response.status).to eq 200
      expect(json['body']).to eq(post.body)
      expect(json['user']['name']).to eq(author.name)
      #expect(valid_schema('user', json)).to be_empty
    end
  end

  describe "POST /users/:user_id/posts" do
    context "with valid attributes" do
      it "create a post in user" do
        expect {
          post user_posts_path(user), valid_attributes , basic_header(author.auth_token)
        }.to change(Post, :count).by(1)
        expect(response.status).to eq 201
        post = user.posts.last
        expect(post.body).to eq(valid_attributes[:body])
        expect(post.user).to eq(author)
        #expect(valid_schema('user', json)).to be_empty
      end
    end

    context "with invalid attributes" do
      it "return the errors in format json" do
        expect {
          post user_posts_path(user), invalid_attributes, basic_header(author.auth_token)
        }.to change(Post, :count).by(0)
        expect(json).to eq({"body"=>["can't be blank"]})
        expect(response.status).to eq 422
      end
    end
  end

  describe "PUT /users/:user_id/posts/:id" do
    it "edit a post of user" do
      post = Post.make!(postable: user)
      put user_post_path(user, post), { body: "New body of post" }, basic_header(author.auth_token)
      expect(response.status).to eq 200
      post.reload
      expect(post.body).to eq("New body of post")
      #expect(valid_schema('user', json)).to be_empty
    end
  end

  describe "DELETE /users/:user_id/posts/:id" do
    it "delete a post of user" do
      post = Post.make!(postable: user)
      expect {
        delete user_post_path(user, post), {}, basic_header(author.auth_token)
      }.to change(Post, :count).by(-1)
      expect(response.status).to eq 204
    end
  end
end