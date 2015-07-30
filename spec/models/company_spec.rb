require 'rails_helper'

RSpec.describe Company, :type => :model do
  it { should belong_to(:profile) }
  it { should belong_to(:country) }
  it { should belong_to(:city) }
  it { should belong_to(:sector) }
  it { should belong_to(:creator) }
  it { should have_many(:company_relations) }
  it { should have_many(:tasks) }
  it { should have_many(:links) }
  it { should have_many(:employment_relations) }
  it { should have_many(:users).through(:employment_relations) }

  # it "Some relations" do
  #   company = Company.make!
  #   5.times { EmploymentRelation.make!(company: company) }
  #   2.times { EmploymentRelation.make!(company: company, admin: true) }
  #   expect(company.employees.count).to eq(7)
  #   expect(company.admins.count).to eq(2)
  # end

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
    describe ".find_or_create_by_name" do
      it "find the company or create one if not exists" do
        company = Company.create(name: "Company")
        new_company = Company.find_or_create_by_name("cOmPaNY")
        expect(new_company).to eq(company)
        new_company = Company.find_or_create_by_name("Other cOmPaNY")
        expect(new_company.name).to eq("Other cOmPaNY")
      end
    end
  end
end
