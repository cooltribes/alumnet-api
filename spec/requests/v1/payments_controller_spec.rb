require 'rails_helper'

describe V1::PaymentsController, type: :request do
  let!(:user) { User.make! }
  let!(:subscription) { Subscription.make!(:lifetime) }
  let!(:country) { Country.make! }

  def valid_attributes
    { paymentable_id: subscription.id, paymentable_type: "Subscription", subtotal: 900, iva: 10, total: 1000, reference: "XXX-XX-001", user_id: user.id, country_id: country.id, city_id: country.cities.first.id, address: "Some address" }
  end

  # describe "GET prizes" do
  #   it "return all prizes " do
  #     3.times { Prize.make! }
  #     get prizes_path,{}, basic_header(user.auth_token)
  #     expect(response.status).to eq 200
  #     expect(json.count).to eq(3)
  #   end
  # end

  describe "POST payments" do
    it "should create a payment" do
      payment = Payment.make!
      expect {
        post payments_path(payment), valid_attributes, basic_header(user.auth_token)
      }.to change(Payment, :count).by(1)
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