require 'rails_helper'

describe V1::Users::PrizesController, type: :request do
  let!(:user) { User.make! }

  describe "GET user prizes" do
    it "return all user prizes " do
      3.times { UserPrize.make!(user: user) }
      get user_prizes_path(user),{}, basic_header(user.auth_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(3)
    end
  end

  #   it "return all attendances of event if params event_id is given" do
  #     event = Event.make!
  #     3.times { Attendance.make! }
  #     5.times { Attendance.make!(event: event) }
  #     get attendances_path, { event_id: event.id }, basic_header(user.auth_token)
  #     expect(response.status).to eq 200
  #     expect(json.count).to eq(5)
  #     expect(json.first['event']['name']).to eq(event.name)
  #   end
  # end

  describe "POST user prizes" do
    it "should create an user prize" do
      prize = Prize.make!
      user = User.make!(:with_points)
      valid_attributes = { prize_id: prize.id, price: prize.price, status: 1, prize_type: prize.prize_type, remaining_quantity: prize.quantity }
      expect {
        post user_prizes_path(user), valid_attributes , basic_header(user.auth_token)
      }.to change(UserPrize, :count).by(1)
    end
  end

  describe "POST user prizes without enough points" do
    it "should get an error message about points" do
      prize = Prize.make!
      user = User.make!
      valid_attributes = { prize_id: prize.id, price: prize.price, status: 1, prize_type: prize.prize_type, remaining_quantity: prize.quantity }
      expect {
        post user_prizes_path(user), valid_attributes , basic_header(user.auth_token)
      }.to change(UserPrize, :count).by(0)
      expect(json['error']).to eq 'user does not have enough points'
    end
  end

  # describe "PUT attendances/:id" do
  #   it "should update a attendances" do
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

  # describe "DELETE attendances/:id" do
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