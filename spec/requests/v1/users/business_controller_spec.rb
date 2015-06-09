require 'rails_helper'
### posts from users

describe V1::Me::BusinessController, type: :request do
  let!(:current_user) { User.make! }

  def valid_attributes
    {       
      offer: "Ofrezco Facere animi quod aut. Qui nulla consequuntur consectetur sapiente.",
      search: "Busco ... Neque dicta enim quasi. Qui corrupti est quisquam. Facere animi quod aut. Qui nulla consequuntur consectetur sapiente.",
    }
  end
  def valid_company_attributes
    { 
      name: "Cooltribes",
      logo: nil,
    }
  end

  def invalid_attributes
    { offer: "", search: "" }
  end

  describe "GET /me/business" do

    before do
      2.times{
        company = Company.make!
        c = CompanyRelation.make!(valid_attributes)
        c.profile = current_user.profile
        c.company = company             
      }
      
    end

    it "should return all companies relations that user has" do
      get me_business_path, {}, basic_header(current_user.auth_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(2)
      #TODO: Validate schema with null value. Groups without parents and children
      #expect(valid_schema('user-array', json)).to be_empty
    end
  end 

  # describe "POST /me/business" do
  #   context "with valid attributes" do
  #     it "should create a company relation for current user" do
  #       expect {
  #         post me_posts_path, valid_attributes , basic_header(current_user.auth_token)
  #       }.to change(Post, :count).by(1)
  #       expect(response.status).to eq 201
  #       post = current_user.posts.last
  #       expect(post.body).to eq(valid_attributes[:body])
  #       expect(post.user).to eq(current_user)
  #       #expect(valid_schema('current_user', json)).to be_empty
  #     end
  #   end

  #   context "with invalid attributes" do
  #     it "sholud return the errors in json format" do
  #       expect {
  #         post me_posts_path, invalid_attributes, basic_header(current_user.auth_token)
  #       }.to change(Post, :count).by(0)
  #       expect(json).to eq({"body"=>["can't be blank"]})
  #       expect(response.status).to eq 422
  #     end
  #   end
  # end


end