require 'rails_helper'

describe V1::TagsController, type: :request do
  let!(:user) { User.make! }

  describe "GET /tags" do
    it "return all tags" do
      user.tag_list.add("tag1", "tag2", "tag3", "tag4")
      user.save
      get tags_path, {}, basic_header(user.auth_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(4)
    end
  end
end