require 'rails_helper'

RSpec.describe Task, :type => :model do
  it { should belong_to(:user) }
  it { should belong_to(:city) }
  it { should belong_to(:country) }

  describe "Callbacks" do
    it "should set post_until dependent of help_type" do
      job = Task.make!(:job)
      expect(job.post_until).to eq(Date.today + 60)
      business = Task.make!(:business)
      expect(business.post_until).to eq(Date.today + 0)
    end
  end
end
