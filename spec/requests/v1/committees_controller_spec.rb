require 'rails_helper'

describe V1::CommitteesController, type: :request do
  let!(:user) { User.make! }

  describe "GET /committees" do
    it "return all committees" do
      get committees_path, {}, basic_header(user.auth_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(10) #created by the User blueprint
    end
  end
end