require 'rails_helper'

RSpec.describe Task, :type => :model do
  it { should belong_to(:user) }
  it { should belong_to(:city) }
  it { should belong_to(:country) }
  it { should have_many(:matches) }
  it { should have_many(:task_invitations) }


  describe "Instance Methods" do
    describe "#apply(user)" do
      it "should find o create a match with the task and user and set applied to true" do
        task = Task.make!(:job)
        user = User.make!
        expect {
          task.apply(user)
        }.to change(Match, :count).by(1)
        expect(Match.last.user).to eq(user)
        expect(Match.last.task).to eq(task)
        expect(Match.last).to be_applied
      end
    end

    describe "#can_apply(user)" do
      it "should return false if user is a creator of task" do
        user = User.make!
        task = Task.make!(:job, user: user)
        expect(task.can_apply(user)).to eq(false)
      end
      it "should return false if user has a match with applied eq true" do
        user = User.make!
        task = Task.make!(:job)
        Match.create!(user: user, task: task, applied: true)
        expect(task.can_apply(user)).to eq(false)
      end
      it "should return true if user has a match with applied eq false" do
        user = User.make!
        task = Task.make!(:job)
        Match.create!(user: user, task: task)
        expect(task.can_apply(user)).to eq(true)
      end
      it "should return true if user has not any match in the task" do
        user = User.make!
        task = Task.make!(:job)
        expect(task.can_apply(user)).to eq(true)
      end
    end
  end

  describe "Callbacks" do
    it "should set post_until dependent of help_type" do
      job = Task.make!(:job)
      expect(job.post_until).to eq(Date.today + 60)
      business = Task.make!(:business)
      expect(business.post_until).to eq(Date.today + 0)
    end
  end
end