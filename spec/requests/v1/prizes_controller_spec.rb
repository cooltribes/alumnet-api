require 'rails_helper'

describe V1::PrizesController, type: :request do
  let!(:user) { User.make! }

  def valid_attributes
    { name: "Prize 1", description: "prize description", price: 50 }
  end

  describe "GET prizes" do
    it "return all prizes " do
      3.times { Prize.make! }
      get prizes_path,{}, basic_header(user.auth_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(3)
    end
  end

  describe "POST prizes" do
    it "should create a prize" do
      prize = Prize.make!
      expect {
        post prizes_path(prize), valid_attributes, basic_header(user.auth_token)
      }.to change(Prize, :count).by(1)
      expect(response.status).to eq 201
    end
  end

  # describe "PUT prizes/:id" do
  #   it "should update a prizes" do
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

  # describe "DELETE prizes/:id" do
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