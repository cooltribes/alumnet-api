require 'rails_helper'

RSpec.describe BusinessRelation do

  def valid_params
    {
      company: { name: "Company Test" },
      offer: "offer",
      search: "search",
      business_me: "business",
      keywords: { offer: [ "Ruby", "PHP" ], search: [ "Sex"] }
    }
  end

  def invalid_params
    {
      company: { name: "Company Test" },
      offer: "",
      search: "",
      business_me: "business",
      keywords: { offer: [ "Ruby", "PHP" ], search: [ "Sex"] }
    }
  end

  let(:user) { User.make! }
  let(:business) { BusinessRelation.new(valid_params, user) }


  describe "#save" do
    it "should be create a company and set user as creator" do
      expect {
        business.save
      }.to change(Company, :count).by(1)
      expect(Company.last.profile).to eq(user.profile)
    end

    it "should be create a company_relation with company and user" do
      expect {
        business.save
      }.to change(CompanyRelation, :count).by(1)
      company_relation = CompanyRelation.last
      expect(company_relation.profile).to eq(user.profile)
      expect(company_relation.company).to eq(Company.last)
    end

    it "should be create a company_relation with company and user" do
      expect {
        business.save
      }.to change(Keyword, :count).by(3)
      company_relation = CompanyRelation.last
      expect(company_relation.offer_keywords.count).to eq(2)
      expect(company_relation.search_keywords.count).to eq(1)
    end

    it {
      business = BusinessRelation.new(invalid_params, user)
      business.save
      expect(business.errors).to eq("")
    }

  end

end