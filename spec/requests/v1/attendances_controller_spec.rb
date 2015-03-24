require 'rails_helper'

describe V1::AttendancesController, type: :request do
  let!(:user) { User.make! }

  describe "GET attendances" do
    it "return all attendances " do
      3.times { Attendance.make! }
      get attendances_path,{}, basic_header(user.auth_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(3)
    end

    it "return all attendances of event if params event_id is given" do
      event = Event.make!
      3.times { Attendance.make! }
      5.times { Attendance.make!(event: event) }
      get attendances_path, { event_id: event.id }, basic_header(user.auth_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(5)
      expect(json.first['event']['name']).to eq(event.name)
    end
  end

  describe "POST attendances" do
    it "should create a attendance" do
      event = Event.make!
      user_to_invite = User.make!
      expect {
        post attendances_path, { user_id: user_to_invite.id, event_id: event.id } , basic_header(user.auth_token)
      }.to change(Attendance, :count).by(1)
      expect(response.status).to eq 201
      expect(json["event"]["id"]).to eq(event.id)
      expect(json["user"]["id"]).to eq(user_to_invite.id)
    end
  end

  describe "PUT attendances/:id" do
    it "should update a attendances" do
      attendance = Attendance.make!(user: user)
      put attendance_path(attendance), { status: 'maybe' }, basic_header(user.auth_token)
      expect(json["status"]).to eq('maybe')
    end
    it "should not update if user is not owner of attendance" do
      attendance = Attendance.make!
      put attendance_path(attendance), { status: 1 }, basic_header(user.auth_token)
      expect(response.status).to eq 403
    end
  end

  describe "DELETE attendances/:id" do
    it "delete a attendance of group" do
      attendance = Attendance.make!(user: user)
      expect {
        delete attendance_path(attendance), {}, basic_header(user.auth_token)
      }.to change(Attendance, :count).by(-1)
      expect(response.status).to eq 204
    end
  end
end