require 'rails_helper'

RSpec.describe TaskAttribute, :type => :model do
  it { should belong_to(:task) }
  it { should belong_to(:attributable) }

  describe "Instance Methods" do
    describe "#find_and_set_attributable" do
      it "should find and set the model attributable to the task_attribute" do
        VCR.use_cassette('create_task') do
          skill = Skill.make!(name: "Ruby")
          task = Task.make!(:job)
          task_attribute = TaskAttribute.new(value: "Ruby", profinda_id: "1001",
            custom_field: "alumnet_skills", attribute_type: "nice_have", task_id: task.id)
          task_attribute.find_and_set_attributable
          expect(task_attribute.attributable).to eq(skill)
        end
      end
    end

  end

  describe "Class Methods" do
    describe ".create_from_dictionaty_object(task, object, type)" do
      it "Should create a new TaskAttribute for given task and set the attributable" do
        VCR.use_cassette('create_task') do
          language = Language.make!(name: "English")
          dictionary_object = {"id" => 1000, "name" => "alumnet_languages", "value" => "English"}
          task = Task.make!(:job)
          expect {
            TaskAttribute.create_from_dictionary_object(task, dictionary_object, "must_have")
          }.to change(TaskAttribute, :count).by(1)
          task_attribute = TaskAttribute.last
          expect(task_attribute).to be_persisted
          expect(task_attribute.value).to eq(dictionary_object["value"])
          expect(task_attribute.profinda_id).to eq(dictionary_object["id"])
          expect(task_attribute.custom_field).to eq(dictionary_object["name"])
          expect(task_attribute.attribute_type).to eq("must_have")
          expect(task_attribute.task).to eq(task)
          expect(task_attribute.attributable).to eq(language)
        end
      end
    end
  end
end
