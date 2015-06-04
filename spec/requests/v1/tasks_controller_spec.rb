require 'rails_helper'

describe V1::TasksController, type: :request do
  let!(:user) { User.make! }

  def valid_attributes
    { post_until: Date.today + 10, description: "testing task", nice_have_list: "1638,1590,1636",
      must_have_list: "1637,1606", duration: "hours", name: "Testing Task in Test" }
  end

  def invalid_attributes
    { post_until: Date.today + 10, description: "testing taks", nice_have_list: "1638,1590,1636",
      must_have_list: "1637,1606", duration: "hours", name: "" }
  end

  describe "GET /tasks" do
    it "return all tasks of current user" do
      3.times { Task.make!(:job) }
      get tasks_path, {}, basic_header(user.auth_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(3)
    end
  end

  describe "GET /tasks/id" do
    it "should return a task" do
      task = Task.make!(:job)
      get task_path(task), {}, basic_header(user.auth_token)
      expect(response.status).to eq 200
      expect(json['name']).to eq(task.name)
    end
  end

  describe "POST /tasks" do
    context "with valid attributes" do
      it "should create a tasks to current user" do
        expect {
          post tasks_path, valid_attributes , basic_header(user.auth_token)
        }.to change(Task, :count).by(1)
        expect(response.status).to eq 201
        expect(Task.last.user).to eq(user)
        expect(Task.last.help_type).to eq("task_job_exchange")
      end
    end
    context "with invalid attributes" do
      it "return the errors in format json" do
        expect {
          post tasks_path, invalid_attributes, basic_header(user.auth_token)
        }.to change(Group, :count).by(0)
        expect(json).to eq({"name"=>["can't be blank"]})
        expect(response.status).to eq 422
      end
    end
  end

  describe "PUT /tasks/:id" do
    it "should update a task" do
      task = Task.make!(:job, user: user)
      put task_path(task), { description: 'new description' }, basic_header(user.auth_token)
      expect(json["description"]).to eq('new description')
    end
  end

  describe "DELETE /tasks/:id" do
    it "delete a task" do
      task = Task.make!(:job, user: user)
      expect {
        delete task_path(task), {}, basic_header(user.auth_token)
      }.to change(Task, :count).by(-1)
      expect(response.status).to eq 204
    end
  end
end