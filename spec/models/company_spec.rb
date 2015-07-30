require 'rails_helper'

RSpec.describe Company, :type => :model do
  it { should belong_to(:profile) }
  it { should belong_to(:country) }
  it { should belong_to(:city) }
  it { should belong_to(:sector) }
  it { should have_many(:company_relations) }
  it { should have_many(:tasks) }

  describe "Validations" do
    it "uniqueness of name" do
      Company.create(name: "Company")
      company = Company.new(name: "cOmPaNY")
      company.save
      expect(company.errors.full_messages).to eq(["Name has already been taken"])
    end
  end
end
