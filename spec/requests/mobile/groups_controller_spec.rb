require 'rails_helper'

describe V1::GroupsController, type: :request do
  let!(:user) { User.make! }

  describe "POST /groups/search" do
    before do
      3.times { Group.make! }
    end

    context "from web" do
      it "return the full version of json of groups" do
        get groups_path, {}, basic_header(user.auth_token)
        expect(response.status).to eq 200
        expect(json["data"].count).to eq(3)
        expect(response).to render_template(:index)
      end
    end

    context "from ios" do
      it "return the mobile version of json of groups" do
        options = { "HTTP_USER_AGENT" => "Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_0_1 like Mac OS X; fr-fr) AppleWebKit/532.9 (KHTML, like Gecko) Mobile/8A306" }
        get groups_path, {}, basic_header(user.auth_token, options)
        expect(response.status).to eq 200
        expect(json["data"].count).to eq(3)
        expect(response).to render_template("mobile/groups")
      end
    end
  end
end