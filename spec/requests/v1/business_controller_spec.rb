require 'rails_helper'

describe V1::BusinessController, type: :request do
  let!(:current_user) { User.make! }

  describe "GET /business" do
    it "should return all companies relations" do
      3.times do
        CompanyRelation.make!
      end
      get business_index_path, {}, basic_header(current_user.auth_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(3)
    end
  end

  describe "GET /business_exchanges/id" do
  end
end