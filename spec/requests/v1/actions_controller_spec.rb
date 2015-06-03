require 'rails_helper'

describe V1::ActionsController, type: :request do
  let!(:user) { User.make! }

  def valid_attributes
    { name: "Action 1", description: "action description", value: 50 }
  end

  describe "GET actions" do
    it "return all actions " do
      3.times { Action.make! }
      get actions_path,{}, basic_header(user.auth_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(3)
    end
  end

  describe "POST actions" do
    it "should create an action" do
      action = Action.make!
      expect {
        post actions_path(action), valid_attributes, basic_header(user.auth_token)
      }.to change(Action, :count).by(1)
      expect(response.status).to eq 201
    end
  end

  # describe "PUT actions/:id" do
  #   it "should update a actions" do
  #     attendance = Attendance.make!(user: user)
  #     put attendance_path(attendance), { status: 'maybe' }, basic_header(user.auth_token)
  #     expect(json["status"]).to eq('maybe')
  #   end
  #   it "should not update if user is not owner of attendance" do
  #     attendance = Attendance.make!
  #     put attendance_path(attendance), { status: 1 }, basic_header(user.auth_token)
  #     expect(response.status).to eq 403
  #   end
  # end

  # describe "DELETE actions/:id" do
  #   it "delete a attendance of group" do
  #     event = Event.make!(creator: user)
  #     attendance = Attendance.make!(user: user, event: event)
  #     expect {
  #       delete attendance_path(attendance), {}, basic_header(user.auth_token)
  #     }.to change(Attendance, :count).by(-1)
  #     expect(response.status).to eq 204
  #   end
  # end
end