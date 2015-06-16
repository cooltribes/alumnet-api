require 'rails_helper'

RSpec.describe CompanyRelation, :type => :model do
  it { should belong_to(:company) }
  it { should belong_to(:profile) }
  it { should have_many(:keywords) }
  it { should validate_presence_of(:offer) }
  it { should validate_presence_of(:search) }

  describe "Instance Methods" do
    describe "offer_keywords=(keywords)" do
      it "should set a new keywords and create them if not exists" do
        company_relation = CompanyRelation.make!
        5.times { CompanyRelationKeyword.make!(:offer, company_relation: company_relation) }
        3.times { CompanyRelationKeyword.make!(:search, company_relation: company_relation) }
        expect(company_relation.offer_keywords.count).to eq(5)
        new_keyword = Keyword.make!
        expect {
          company_relation.offer_keywords =["keywords 1", "keywords 2", new_keyword.name]
        }.to change(Keyword, :count).by(2)
        expect(company_relation.offer_keywords.count).to eq(3)
        expect(company_relation.search_keywords.count).to eq(3)
      end
    end

    describe "search_keywords=(keywords)" do
      it("should be the same as offer_keywords=(keywords)"){}
    end
  end
end
