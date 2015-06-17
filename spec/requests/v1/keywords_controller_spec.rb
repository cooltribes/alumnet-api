require 'rails_helper'

describe V1::KeywordsController, type: :request do
  let!(:user) { User.make! }

  describe "GET /keywords" do
    it "return all keywords" do
      3.times { Keyword.make! }
      get keywords_path, {}, basic_header(user.auth_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(3)
    end
  end

  describe "POST /keywords" do
    context "with valid attributes" do
      it "should create a keyword" do
        expect {
          post keywords_path, { name: "New Keyword" }, basic_header(user.auth_token)
        }.to change(Keyword, :count).by(1)
        expect(response.status).to eq 201
      end
    end
    context "with invalid attributes" do
      it "return the errors in format json" do
        expect {
          post keywords_path, { name: ""  }, basic_header(user.auth_token)
        }.to change(Keyword, :count).by(0)
        expect(json).to eq({"name"=>["can't be blank"]})
        expect(response.status).to eq 422
      end
    end
  end

  describe "PUT /keywords/:id" do
    it "should update a keyword" do
      keyword = Keyword.make!
      put keyword_path(keyword), { name: "New Name" }, basic_header(user.auth_token)
      expect(json["name"]).to eq("New Name")
    end
  end

  describe "DELETE /keywords/:id" do
    it "delete a keyword" do
      keyword = Keyword.make!
      expect {
        delete keyword_path(keyword), {}, basic_header(user.auth_token)
      }.to change(Keyword, :count).by(-1)
      expect(response.status).to eq 204
    end
  end
end