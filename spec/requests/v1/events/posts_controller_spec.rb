require 'rails_helper'
### posts from events

describe V1::Events::PostsController, type: :request do
  let!(:admin) { User.make! }
  let!(:event) { Event.make! }

  def valid_attributes
    { body: "Neque dicta enim quasi. Qui corrupti est quisquam. Facere animi quod aut. Qui nulla consequuntur consectetur sapiente." }
  end

  def invalid_attributes
    { body: "" }
  end

  describe "GET /events/:event_id/posts" do

    before do
      5.times { Post.make!(postable: event)  }
    end

    it "return all posts of event" do
      get event_posts_path(event), {}, basic_header(admin.auth_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(5)
      #TODO: Validate schema with null value. Events without parents and children
      #expect(valid_schema('event-array', json)).to be_empty
    end
  end

  describe "GET /events/:event_id/posts/:id" do
    it "return a post of a event by id" do
      post = Post.make!(postable: event)
      get event_post_path(event, post), {}, basic_header(admin.auth_token)
      expect(response.status).to eq 200
      expect(json).to have_key('user')
      expect(json).to have_key('body')
      expect(json).to have_key('created_at')
      #expect(valid_schema('event', json)).to be_empty
    end
  end

  describe "POST /events/:event_id/posts" do
    context "with valid attributes" do
      it "create a post in event" do
        expect {
          post event_posts_path(event), valid_attributes , basic_header(admin.auth_token)
        }.to change(Post, :count).by(1)
        expect(response.status).to eq 201
        post = event.posts.last
        expect(post.body).to eq(valid_attributes[:body])
        expect(post.user).to eq(admin)
        #expect(valid_schema('event', json)).to be_empty
      end
    end

    context "with invalid attributes" do
      it "return the errors in format json" do
        expect {
          post event_posts_path(event), invalid_attributes, basic_header(admin.auth_token)
        }.to change(Post, :count).by(0)
        expect(json).to eq({"body"=>["can't be blank"]})
        expect(response.status).to eq 422
      end
    end
  end

  describe "PUT /events/:event_id/posts/:id" do
    it "edit a post of event" do
      post = Post.make!(postable: event, user: admin)
      put event_post_path(event, post), { body: "New body of post" }, basic_header(admin.auth_token)
      expect(response.status).to eq 200
      post.reload
      expect(post.body).to eq("New body of post")
      #expect(valid_schema('event', json)).to be_empty
    end
  end

  describe "DELETE /events/:event_id/posts/:id" do
    it "delete a post of event" do
      post = Post.make!(postable: event, user: admin)
      expect {
        delete event_post_path(event, post), {}, basic_header(admin.auth_token)
      }.to change(Post, :count).by(-1)
      expect(response.status).to eq 204
    end
  end
end