require 'rails_helper'
### posts from users

describe V1::Me::BusinessController, type: :request do
  let!(:current_user) { User.make! }

  def valid_attributes
    { body: "Neque dicta enim quasi. Qui corrupti est quisquam. Facere animi quod aut. Qui nulla consequuntur consectetur sapiente." }
  end

  def invalid_attributes
    { body: "" }
  end

  describe "GET /me/business" do

    # before do
    #   group_a = Group.make!
    #   Membership.make!(:approved, user: current_user, group: group_a)
    #   group_b = Group.make!
    #   Membership.make!(:approved, user: current_user, group: group_b)
    #   2.times { Post.make!(postable: group_a) }
    #   2.times { Post.make!(postable: group_b) }
    # end

    it "return all posts of groups where user is member" do
      get me_business_relations_path, {}, basic_header(current_user.auth_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(4)
      #TODO: Validate schema with null value. Groups without parents and children
      #expect(valid_schema('user-array', json)).to be_empty
    end
  end 
end