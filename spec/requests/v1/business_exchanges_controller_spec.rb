require 'rails_helper'

describe V1::BusinessExchangesController, type: :request do
  let!(:user) { User.make! }

  def valid_attributes
    { post_until: Date.today + 10, description: "testing task", nice_have_list: "1638,1590,1636",
      must_have_list: "1637,1606", duration: "hours", name: "Testing Task in Test" }
  end

  def invalid_attributes
    { post_until: Date.today + 10, description: "testing taks", nice_have_list: "1638,1590,1636",
      must_have_list: "1637,1606", duration: "hours", name: "" }
  end

  describe "GET /business_exchanges" do
    it "return all business_exchanges" do
      VCR.use_cassette('request_tasks_index') do
        3.times { Task.make!(:job) }
        3.times { Task.make!(:business) }
      end
      get business_exchanges_path, {}, basic_header(user.auth_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(3)
    end
  end

  describe "GET /business_exchanges/my" do
    it "return only business_exchanges of current user" do
      VCR.use_cassette('request_tasks_my') do
        3.times { Task.make!(:business) }
        2.times { Task.make!(:business, user: user) }
        3.times { Task.make!(:job) }
      end
      get my_business_exchanges_path, {}, basic_header(user.auth_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(2)
    end
  end

  describe "GET /business_exchanges/applied" do
    it "return only business_exchanges where the current user has applied" do
      VCR.use_cassette('request_tasks_apply') do
        3.times { Task.make!(:business) }
        1.times { Task.make!(:business).apply(user) }
      end
      get applied_business_exchanges_path, {}, basic_header(user.auth_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(1)
    end
  end

  describe "GET /business_exchanges/id" do
    it "should return a task" do
      VCR.use_cassette('create_task') do
        task = Task.make!(:business)
        get business_exchange_path(task), {}, basic_header(user.auth_token)
        expect(response.status).to eq 200
        expect(json['name']).to eq(task.name)
      end
    end
  end

  describe "PUT /business_exchanges/apply" do
    it "should set apply to true and return a task" do
      VCR.use_cassette('create_task') do
        task = Task.make!(:business)
        put apply_business_exchange_path(task), {}, basic_header(user.auth_token)
        expect(response.status).to eq 200
        expect(json["user_applied"]).to eq(true)
        expect(json["user_can_apply"]).to eq(false)
      end
    end
  end

  describe "POST /business_exchanges" do
    context "with valid attributes" do
      it "should create a business_exchanges to current user" do
        VCR.use_cassette('request_tasks_create') do
          expect {
            post business_exchanges_path, valid_attributes , basic_header(user.auth_token)
          }.to change(Task, :count).by(1)
          expect(response.status).to eq 201
          expect(Task.last.user).to eq(user)
          expect(Task.last.help_type).to eq("task_business_exchange")
        end
      end
    end
    context "with invalid attributes" do
      it "return the errors in format json" do
        expect {
          post business_exchanges_path, invalid_attributes, basic_header(user.auth_token)
        }.to change(Task, :count).by(0)
        expect(json).to eq({"name"=>["can't be blank"]})
        expect(response.status).to eq 422
      end
    end
  end

  describe "PUT /business_exchanges/:id" do
    it "should update a task" do
      VCR.use_cassette('request_tasks_update') do
        task = Task.make!(:business, user: user)
        put business_exchange_path(task), { description: 'new description' }, basic_header(user.auth_token)
        expect(json["description"]).to eq('new description')
      end
    end
  end

  describe "DELETE /business_exchanges/:id" do
    it "delete a task" do
      VCR.use_cassette('create_task') do
        task = Task.make!(:business, user: user)
        expect {
          delete business_exchange_path(task), {}, basic_header(user.auth_token)
        }.to change(Task, :count).by(-1)
        expect(response.status).to eq 204
      end
    end
  end
end