require 'rails_helper'
### posts from groups

describe V1::Groups::PostsController, type: :request do
  let!(:admin) { User.make! }
  let!(:group) { Group.make! }

  def valid_attributes
    { body: "Neque dicta enim quasi. Qui corrupti est quisquam. Facere animi quod aut. Qui nulla consequuntur consectetur sapiente." }
  end

  def invalid_attributes
    { body: "" }
  end

  describe "GET /groups/:group_id/posts" do

    before do
      5.times { Post.make!(postable: group)  }
    end

    it "return all posts of group" do
      get group_posts_path(group), {}, basic_header(admin.api_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(5)
      #TODO: Validate schema with null value. Groups without parents and children
      #expect(valid_schema('group-array', json)).to be_empty
    end
  end

  describe "GET /groups/:group_id/posts/:id" do
    it "return a post of a group by id" do
      post = Post.make!(postable: group)
      get group_post_path(group, post), {}, basic_header(admin.api_token)
      expect(response.status).to eq 200
      expect(json).to have_key('user')
      expect(json).to have_key('body')
      expect(json).to have_key('created_at')
      #expect(valid_schema('group', json)).to be_empty
    end
  end

  describe "POST /groups/:group_id/posts" do
    context "with valid attributes" do
      it "create a post in group" do
        expect {
          post group_posts_path(group), valid_attributes , basic_header(admin.api_token)
        }.to change(Post, :count).by(1)
        expect(response.status).to eq 201
        post = group.posts.last
        expect(post.body).to eq(valid_attributes[:body])
        expect(post.user).to eq(admin)
        #expect(valid_schema('group', json)).to be_empty
      end
    end

    context "with invalid attributes" do
      it "return the errors in format json" do
        expect {
          post group_posts_path(group), invalid_attributes, basic_header(admin.api_token)
        }.to change(Post, :count).by(0)
        expect(json).to eq({"body"=>["can't be blank"]})
        expect(response.status).to eq 422
      end
    end
  end

  describe "PUT /groups/:group_id/posts/:id" do
    it "edit a post of group" do
      post = Post.make!(postable: group)
      put group_post_path(group, post), { body: "New body of post" }, basic_header(admin.api_token)
      expect(response.status).to eq 200
      post.reload
      expect(post.body).to eq("New body of post")
      #expect(valid_schema('group', json)).to be_empty
    end
  end

  describe "DELETE /groups/:group_id/posts/:id" do
    it "delete a post of group" do
      post = Post.make!(postable: group)
      expect {
        delete group_post_path(group, post), {}, basic_header(admin.api_token)
      }.to change(Post, :count).by(-1)
      expect(response.status).to eq 204
    end
  end
end