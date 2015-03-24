require 'rails_helper'
### posts from users

describe V1::Me::PostsController, type: :request do
  let!(:current_user) { User.make! }

  def valid_attributes
    { body: "Neque dicta enim quasi. Qui corrupti est quisquam. Facere animi quod aut. Qui nulla consequuntur consectetur sapiente." }
  end

  def invalid_attributes
    { body: "" }
  end

  describe "GET /me/posts" do

    before do
      group_a = Group.make!
      Membership.make!(:approved, user: current_user, group: group_a)
      group_b = Group.make!
      Membership.make!(:approved, user: current_user, group: group_b)
      2.times { Post.make!(postable: group_a) }
      2.times { Post.make!(postable: group_b) }
    end

    it "return all posts of groups where user is member" do
      get me_posts_path, {}, basic_header(current_user.auth_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(4)
      #TODO: Validate schema with null value. Groups without parents and children
      #expect(valid_schema('user-array', json)).to be_empty
    end
  end

  describe "GET /me/posts/:id" do
    it "return a post of current user by id" do
      post = Post.make!(postable: current_user)
      get me_post_path(post), {}, basic_header(current_user.auth_token)
      expect(response.status).to eq 200
      expect(json['body']).to eq(post.body)
      expect(json['user']['name']).to eq(post.user.permit_name(current_user))
      #expect(valid_schema('current_user', json)).to be_empty
    end
  end

  describe "POST /me/posts" do
    context "with valid attributes" do
      it "create a post in current user" do
        expect {
          post me_posts_path, valid_attributes , basic_header(current_user.auth_token)
        }.to change(Post, :count).by(1)
        expect(response.status).to eq 201
        post = current_user.posts.last
        expect(post.body).to eq(valid_attributes[:body])
        expect(post.user).to eq(current_user)
        #expect(valid_schema('current_user', json)).to be_empty
      end
    end

    context "with invalid attributes" do
      it "return the errors in format json" do
        expect {
          post me_posts_path, invalid_attributes, basic_header(current_user.auth_token)
        }.to change(Post, :count).by(0)
        expect(json).to eq({"body"=>["can't be blank"]})
        expect(response.status).to eq 422
      end
    end
  end

  describe "PUT /me/posts/:id" do
    it "edit a post of current user" do
      post = Post.make!(postable: current_user, user: current_user)
      put me_post_path(post), { body: "New body of post" }, basic_header(current_user.auth_token)
      expect(response.status).to eq 200
      post.reload
      expect(post.body).to eq("New body of post")
      #expect(valid_schema('current_user', json)).to be_empty
    end
  end

  describe "DELETE /me/posts/:id" do
    it "delete a post of current user" do
      post = Post.make!(postable: current_user, user: current_user)
      expect {
        delete me_post_path(post), {}, basic_header(current_user.auth_token)
      }.to change(Post, :count).by(-1)
      expect(response.status).to eq 204
    end
  end
end