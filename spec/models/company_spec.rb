require 'rails_helper'

RSpec.describe Company, :type => :model do
  it { should belong_to(:profile) }
  it { should belong_to(:country) }
  it { should belong_to(:city) }
  it { should belong_to(:sector) }
  it { should have_many(:company_relations) }
  it { should have_many(:tasks) }
  it { should have_many(:links) }


  describe "Validations" do
    it "uniqueness of name" do
      Company.create(name: "Company")
      company = Company.new(name: "cOmPaNY")
      company.save
      expect(company.errors.full_messages).to eq(["Name has already been taken"])
    end
  end

  describe "Class Methods" do
    describe ".find_by_name" do
      it "find the company name" do
        Company.create(name: "Company")
        company = Company.find_by_name("cOmPaNY")
        expect(company.name).to eq("Company")
      end
    end
  end
end
