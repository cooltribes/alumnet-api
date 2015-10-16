require 'rails_helper'

describe V1::Posts::LikesController, type: :request do
  let!(:user) { User.make! }
  let!(:post_model) { Post.make! }

  describe "GET /posts/:post_id/likes" do
    before do
      5.times { Like.make!(likeable: post_model) }
    end

    it "return all likes of post" do
      get post_likes_path(post_model), {}, basic_header(user.auth_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(5)
      expect(json.last["user"]["id"]).to eq(User.last.id)
    end
  end
end