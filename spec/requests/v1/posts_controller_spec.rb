require 'rails_helper'
## access to post info.

describe V1::PostsController, type: :request do
  let!(:admin) { User.make! }

  describe "GET /posts/:id" do
    it "return a post by id" do
      post = Post.make!(postable: Group.make!)
      get post_path(post), {}, basic_header(admin.api_token)
      expect(response.status).to eq 200
      #expect(valid_schema('group', json)).to be_empty
    end
  end
end