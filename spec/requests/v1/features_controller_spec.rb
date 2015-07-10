require 'rails_helper'

describe V1::FeaturesController, type: :request do
  let!(:user) { User.make! }

  def valid_attributes
    { name: "Feature 1", description: "feature description", key_name: "feature_1" }
  end

  describe "GET features" do
    it "return all features " do
      3.times { Feature.make! }
      get features_path,{}, basic_header(user.auth_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(3)
    end
  end

  describe "POST features" do
    it "should create a feature" do
      feature = Feature.make!
      expect {
        post features_path(feature), valid_attributes, basic_header(user.auth_token)
      }.to change(Feature, :count).by(1)
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