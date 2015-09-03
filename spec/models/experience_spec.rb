require 'rails_helper'

RSpec.describe Experience, :type => :model do
  it { should belong_to(:profile) }
  it { should belong_to(:seniority) }

end

describe 'Callbacks' do
  describe 'update_profinda_profile' do
    pending "Test delayed action"
    # it 'it should delayed the action for update profile in profinda api' do
    #   user = User.make!(status: 1)
    #   experience = Experience.make(profile: user.profile)
    #   expect {
    #     experience.save
    #   }.to change(SaveProfindaProfileJob.jobs, :size).by(1)
    # end
  end

  describe "check_company" do
    it "if exists a company with organization_name then set to experience" do
      company = Company.make!
      experience = Experience.make(organization_name: company.name)
      expect(experience.company).to eq(nil)
      experience.save
      expect(experience.company).to eq(company)
    end
  end
end