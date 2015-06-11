require 'rails_helper'

RSpec.describe TaskInvitation, :type => :model do
  it { should belong_to(:user) }
  it { should belong_to(:task) }

  describe "Instance Methods" do

    let(:user) { User.make! }
    let(:task) { Task.make!(:job) }
    let!(:invitation) { TaskInvitation.create!(user: user, task: task )}

    describe "#accept!" do
      it "should set accepted to true" do
        invitation.accept!
        expect(invitation).to be_accepted
      end

      it "should create a new match between task and user with applied eq true" do
        expect {
          invitation.accept!
        }.to change(Match, :count).by(1)
        expect(Match.last).to be_applied
        expect(Match.last.user).to eq(user)
        expect(Match.last.task).to eq(task)
      end
    end
  end
end
