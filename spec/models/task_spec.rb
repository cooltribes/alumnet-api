require 'rails_helper'

RSpec.describe Task, :type => :model do
  it { should belong_to(:user) }
  it { should belong_to(:city) }
  it { should belong_to(:country) }
  it { should belong_to(:seniority) }
  it { should have_many(:matches) }
  it { should have_many(:task_invitations) }
  it { should have_many(:task_attributes) }


  describe "Instance Methods" do
    describe "#apply(user)" do
      it "should find o create a match with the task and user and set applied to true" do
        VCR.use_cassette('create_task') do
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
    end

    describe "#can_apply(user)" do
      it "should return false if user is a creator of task" do
        VCR.use_cassette('create_task') do
          user = User.make!
          task = Task.make!(:job, user: user)
          expect(task.can_apply(user)).to eq(false)
        end
      end
      it "should return false if user has a match with applied eq true" do
        VCR.use_cassette('create_task') do
          user = User.make!
          task = Task.make!(:job)
          Match.create!(user: user, task: task, applied: true)
          expect(task.can_apply(user)).to eq(false)
        end
      end
      it "should return true if user has a match with applied eq false" do
        VCR.use_cassette('create_task') do
          user = User.make!
          task = Task.make!(:job)
          Match.create!(user: user, task: task)
          expect(task.can_apply(user)).to eq(true)
        end
      end
      it "should return true if user has not any match in the task" do
        VCR.use_cassette('create_task') do
          user = User.make!
          task = Task.make!(:job)
          expect(task.can_apply(user)).to eq(true)
        end
      end
    end

    describe "#get_dictionary_object_from_profinda(attribute_type)" do
      it "should return the dictionary_objects from profinda" do
        # dictionary_objects = [{"id" => 1000, "name" => "alumnet_skills", "value" => "Ruby"},
        #   {"id" => 1001, "name" => "alumnet_languages", "value" => "English"}]
        # allow_any_instance_of(ProfindaAdminApi).to receive(:dictionary_objects_by_id).
        # with(["1000","1001"]).and_return(dictionary_objects)
        # task = Task.make!(:job, nice_have_list: "1000,1001")
        # expect(task.get_dictionary_object_from_profinda).to eq(dictionary_objects)
      end
    end

    describe "#set_task_attributes_from_profinda(attribute_type)" do
      it "should create task_attributes from the dictonary objects of profinda" do
      end
    end
  end

  describe "Callbacks" do
    it "should set post_until dependent of help_type" do
      VCR.use_cassette('task_help_type_callback') do
        job = Task.make!(:job)
        expect(job.post_until).to eq(Date.today + 60)
        business = Task.make!(:business, post_until: Date.today + 5)
        expect(business.post_until).to eq(Date.today + 5)
      end
    end
  end
end
