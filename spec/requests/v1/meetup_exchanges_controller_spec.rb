require 'rails_helper'

describe V1::MeetupExchangesController, type: :request do
  let!(:user) { User.make! }

  def valid_attributes
    { arrival_date: Date.today - 5, post_until: Date.today + 10, description: "testing task",
      nice_have_list: "1638,1590,1636", must_have_list: "1637,1606", duration: "hours",
      name: "Testing Task in Test" }
  end

  def invalid_attributes
    { post_until: Date.today + 10, description: "testing taks", nice_have_list: "1638,1590,1636",
      must_have_list: "1637,1606", duration: "hours", name: "" }
  end

  describe "GET /meetup_exchanges" do
    it "return all meetup_exchanges" do
      VCR.use_cassette('request_tasks_index') do
        3.times { Task.make!(:job) }
        3.times { Task.make!(:meetup) }
      end
      get meetup_exchanges_path, {}, basic_header(user.auth_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(3)
    end
  end

  describe "GET /meetup_exchanges/my" do
    it "return only meetup_exchanges of current user" do
      VCR.use_cassette('request_tasks_my') do
        3.times { Task.make!(:meetup) }
        2.times { Task.make!(:meetup, user: user) }
        3.times { Task.make!(:job) }
      end
      get my_meetup_exchanges_path, {}, basic_header(user.auth_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(2)
    end
  end

  describe "GET /meetup_exchanges/applied" do
    it "return only meetup_exchanges where the current user has applied" do
      VCR.use_cassette('request_tasks_apply') do
        3.times { Task.make!(:meetup) }
        1.times { Task.make!(:meetup).apply(user) }
      end
      get applied_meetup_exchanges_path, {}, basic_header(user.auth_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(1)
    end
  end

  describe "GET /meetup_exchanges/id" do
    it "should return a task" do
      VCR.use_cassette('create_task') do
        task = Task.make!(:meetup)
        get meetup_exchange_path(task), {}, basic_header(user.auth_token)
        expect(response.status).to eq 200
        expect(json['name']).to eq(task.name)
        expect(json['arrival_date']).to eq(task.arrival_date)
      end
    end
  end

  describe "PUT /meetup_exchanges/apply" do
    it "should set apply to true and return a task" do
      VCR.use_cassette('create_task') do
        task = Task.make!(:meetup)
        put apply_meetup_exchange_path(task), {}, basic_header(user.auth_token)
        expect(response.status).to eq 200
        expect(json["user_applied"]).to eq(true)
        expect(json["user_can_apply"]).to eq(false)
      end
    end
  end

  describe "POST /meetup_exchanges" do
    context "with valid attributes" do
      it "should create a meetup_exchanges to current user" do
        VCR.use_cassette('request_tasks_create') do
          expect {
            post meetup_exchanges_path, valid_attributes , basic_header(user.auth_token)
          }.to change(Task, :count).by(1)
          expect(response.status).to eq 201
          expect(Task.last.user).to eq(user)
          expect(Task.last.help_type).to eq("task_meetup_exchange")
        end
      end
    end
    context "with invalid attributes" do
      it "return the errors in format json" do
        expect {
          post meetup_exchanges_path, invalid_attributes, basic_header(user.auth_token)
        }.to change(Task, :count).by(0)
        expect(json).to eq({"name"=>["can't be blank"]})
        expect(response.status).to eq 422
      end
    end
  end

  describe "PUT /meetup_exchanges/:id" do
    it "should update a task" do
      VCR.use_cassette('request_tasks_update') do
        task = Task.make!(:meetup, user: user)
        put meetup_exchange_path(task), { description: 'new description' }, basic_header(user.auth_token)
        expect(json["description"]).to eq('new description')
      end
    end
  end

  describe "DELETE /meetup_exchanges/:id" do
    it "delete a task" do
      VCR.use_cassette('create_task') do
        task = Task.make!(:meetup, user: user)
        expect {
          delete meetup_exchange_path(task), {}, basic_header(user.auth_token)
        }.to change(Task, :count).by(-1)
        expect(response.status).to eq 204
      end
    end
  end
end