require 'rails_helper'

describe V1::BaseController do

  describe "Handle Errors" do
    let!(:user){ User.make! }
    context "ActiveRecord::RecordNotFound" do
      it "should return json response with code 404" do
        get "/countries/25", {}, basic_header(user.auth_token)
        expect(response.status).to eq(404)
      end
    end
  end

end
