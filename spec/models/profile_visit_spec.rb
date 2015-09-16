require 'rails_helper'

RSpec.describe ProfileVisit, type: :model do
  describe "class methods" do
    describe ".create_visit(user, visitor, reference)" do
      context "first visit" do
        it "should create a new record" do
          user = User.make!
          visitor = User.make!
          expect {
            ProfileVisit.create_visit(user, visitor)
          }.to change(ProfileVisit, :count).by(1)
          expect(ProfileVisit.last.user).to eq(user)
          expect(ProfileVisit.last.visitor).to eq(visitor)
        end
      end

      context "other visit before 1 day" do
        it "should not create a new record" do
          user = User.make!
          visitor = User.make!
          ProfileVisit.create_visit(user, visitor)
          expect {
            ProfileVisit.create_visit(user, visitor)
          }.to change(ProfileVisit, :count).by(0)
        end
      end

      context "other visit after 1 day" do
        it "should create a new record" do
          user = User.make!
          visitor = User.make!
          ProfileVisit.create!(user: user, visitor: visitor, created_at: Date.today - 2)
          expect {
            ProfileVisit.create_visit(user, visitor)
          }.to change(ProfileVisit, :count).by(1)
        end
      end
    end
  end
end
