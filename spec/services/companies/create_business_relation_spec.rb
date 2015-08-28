require 'rails_helper'

RSpec.describe Companies::CreateBusinessRelation, type: :service do

  def valid_params
    {
      company_name: "Company Test",
      offer: "offer",
      search: "search",
      business_me: "business",
      offer_keywords: [ "Ruby", "PHP" ],
      search_keywords: ["Sex"]
    }
  end

  def invalid_params
    {
      company_name: "Company Test",
      company_logo: "",
      offer: "",
      search: "",
      business_me: "",
      offer_keywords: [ "Ruby", "PHP" ],
      search_keywords: "Sex"
    }
  end

  let(:user) { User.make! }
  let(:business) { ::Companies::CreateBusinessRelation.new(valid_params, user) }


  describe "#call" do
    it "should be create a company and set user as creator" do
      expect {
        business.call
      }.to change(Company, :count).by(1)
      expect(Company.last.creator).to eq(user)
    end

    it "should be create a company_relation with company and user" do
      expect {
        business.call
      }.to change(CompanyRelation, :count).by(1)
      company_relation = CompanyRelation.last
      expect(company_relation.profile).to eq(user.profile)
      expect(company_relation.company).to eq(Company.last)
    end

    it "should be create a company_relation with company and user" do
      expect {
        business.call
      }.to change(Keyword, :count).by(3)
      company_relation = CompanyRelation.last
      expect(business.company_relation).to eq(company_relation)
      expect(company_relation.offer_keywords.count).to eq(2)
      expect(company_relation.search_keywords.count).to eq(1)
    end

    it "should return errors" do
      business = ::Companies::CreateBusinessRelation.new(invalid_params, user)
      business.valid?
      expect(business.errors.full_messages).to eq(["Offer can't be blank",
        "Search can't be blank", "Search keywords must be an array"])
    end

  end

end