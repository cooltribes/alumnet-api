require 'rails_helper'

describe V1::LanguagesController, type: :request do
  let!(:user) { User.make! }

  describe "GET /languages" do
    it "return all languages" do
      3.times { Language.make! }
      get languages_path, {}, basic_header(user.api_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(3)
    end
  end
end